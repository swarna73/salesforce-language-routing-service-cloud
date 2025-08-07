import pandas as pd
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime, timedelta
import os

# Configuration
FILE_PATH = "/Users/swarnalathaswaminathan/Documents/Notify_Contract_expiry/Contract.xls"

# Email configuration
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USER = 'swarnalatha73@gmail.com'  # Replace with your Gmail
EMAIL_PASSWORD = 'uijs akob bhhn vuoz'  # Replace with 16-character app password
RECIPIENT_EMAIL = 'autotestuser7383@gmail.com'  # Replace with recipient email

# Days before expiry to send notification
DAYS_BEFORE_EXPIRY = 30

def read_contract_file(file_path):
    """Read contract file - handles both CSV and Excel formats"""
    try:
        # Try reading as CSV first
        df = pd.read_csv(file_path)
        print("File read successfully as CSV!")
        return df
    except:
        try:
            # Try reading as Excel with different engines
            df = pd.read_excel(file_path, engine='xlrd')
            print("File read successfully as Excel!")
            return df
        except:
            try:
                df = pd.read_excel(file_path, engine='openpyxl')
                print("File read successfully as Excel (openpyxl)!")
                return df
            except Exception as e:
                print(f"Error reading file: {e}")
                return None

def parse_date(date_str):
    """Parse date string in various formats"""
    if pd.isna(date_str) or date_str == '':
        return None
    
    # Common date formats to try
    date_formats = [
        '%d-%m-%Y',  # 17-07-2025
        '%d/%m/%Y',  # 17/07/2025
        '%Y-%m-%d',  # 2025-07-17
        '%m/%d/%Y',  # 07/17/2025
        '%d.%m.%Y',  # 17.07.2025
    ]
    
    date_str = str(date_str).strip()
    
    for fmt in date_formats:
        try:
            return datetime.strptime(date_str, fmt).date()
        except ValueError:
            continue
    
    print(f"Warning: Could not parse date: {date_str}")
    return None

def get_expiring_contracts(df):
    """Get contracts expiring within the specified days"""
    
    # Print column names to help identify the correct columns
    print("Available columns:", df.columns.tolist())
    
    # Try to identify date and vendor columns automatically
    date_column = None
    vendor_column = None
    
    # Look for date column
    for col in df.columns:
        col_lower = col.lower()
        if any(keyword in col_lower for keyword in ['date', 'expiry', 'expire', 'end']):
            date_column = col
            break
    
    # Look for vendor column
    for col in df.columns:
        col_lower = col.lower()
        if any(keyword in col_lower for keyword in ['vendor', 'supplier', 'company', 'contractor']):
            vendor_column = col
            break
    
    if not date_column:
        print("Could not automatically detect date column. Please specify manually.")
        print("Available columns:", df.columns.tolist())
        return []
    
    print(f"Using date column: {date_column}")
    print(f"Using vendor column: {vendor_column if vendor_column else 'Not found - will use index'}")
    
    # Calculate cutoff date
    today = datetime.now().date()
    cutoff_date = today + timedelta(days=DAYS_BEFORE_EXPIRY)
    
    expiring_contracts = []
    
    for index, row in df.iterrows():
        expiry_date = parse_date(row[date_column])
        
        if expiry_date and today <= expiry_date <= cutoff_date:
            days_remaining = (expiry_date - today).days
            
            # Get vendor info
            vendor = row[vendor_column] if vendor_column and vendor_column in row else f"Contract {index + 1}"
            
            contract_info = {
                'vendor': str(vendor).strip(),
                'expiry_date': expiry_date,
                'days_remaining': days_remaining,
                'row_data': row.to_dict()  # Include all row data for additional details
            }
            
            expiring_contracts.append(contract_info)
    
    # Sort by days remaining (most urgent first)
    expiring_contracts.sort(key=lambda x: x['days_remaining'])
    
    return expiring_contracts

def create_email_body(expiring_contracts):
    """Create consolidated email body with all expiring contracts"""
    
    if not expiring_contracts:
        return "No contracts are expiring within the next 30 days."
    
    body = f"""
CONTRACT EXPIRY NOTIFICATION
============================

The following {len(expiring_contracts)} contract(s) are expiring within the next {DAYS_BEFORE_EXPIRY} days:

"""
    
    for i, contract in enumerate(expiring_contracts, 1):
        urgency = "🔴 URGENT" if contract['days_remaining'] <= 7 else "🟡 ATTENTION" if contract['days_remaining'] <= 15 else "🟢 NOTICE"
        
        body += f"""
{i}. {urgency}
   Vendor: {contract['vendor']}
   Expiry Date: {contract['expiry_date'].strftime('%d-%m-%Y')}
   Days Remaining: {contract['days_remaining']} days
   
   Additional Details:
"""
        
        # Add relevant details from the row (excluding the date and vendor columns we already showed)
        for key, value in contract['row_data'].items():
            if key.lower() not in ['vendor', 'supplier', 'company', 'contractor'] and \
               not any(keyword in key.lower() for keyword in ['date', 'expiry', 'expire', 'end']):
                if pd.notna(value) and str(value).strip():
                    body += f"   {key}: {value}\n"
        
        body += "\n" + "-" * 50 + "\n"
    
    body += f"""

SUMMARY:
- Total contracts expiring: {len(expiring_contracts)}
- Most urgent expiry: {min(contract['days_remaining'] for contract in expiring_contracts)} days
- Contracts expiring within 7 days: {sum(1 for c in expiring_contracts if c['days_remaining'] <= 7)}
- Contracts expiring within 15 days: {sum(1 for c in expiring_contracts if c['days_remaining'] <= 15)}

Please take appropriate action to renew or replace these contracts before they expire.

This notification was generated automatically on {datetime.now().strftime('%d-%m-%Y at %H:%M')}.
"""
    
    return body

def send_consolidated_email(expiring_contracts):
    """Send one consolidated email with all expiring contracts"""
    
    try:
        # Create email subject
        if not expiring_contracts:
            subject = "Contract Expiry Report - No Upcoming Expiries"
        else:
            urgent_count = sum(1 for c in expiring_contracts if c['days_remaining'] <= 7)
            if urgent_count > 0:
                subject = f"🔴 URGENT: {len(expiring_contracts)} Contract(s) Expiring Soon ({urgent_count} within 7 days)"
            else:
                subject = f"Contract Expiry Notification - {len(expiring_contracts)} Contract(s) Expiring Within 30 Days"
        
        # Create email body
        body = create_email_body(expiring_contracts)
        
        # Create message
        msg = MIMEMultipart()
        msg['From'] = EMAIL_USER
        msg['To'] = RECIPIENT_EMAIL
        msg['Subject'] = subject
        
        # Add body to email
        msg.attach(MIMEText(body, 'plain'))
        
        # Send email
        server = smtplib.SMTP(EMAIL_HOST, EMAIL_PORT)
        server.starttls()
        server.login(EMAIL_USER, EMAIL_PASSWORD)
        
        text = msg.as_string()
        server.sendmail(EMAIL_USER, RECIPIENT_EMAIL, text)
        server.quit()
        
        print(f"✓ Consolidated email sent successfully to {RECIPIENT_EMAIL}")
        print(f"  Subject: {subject}")
        print(f"  Contracts included: {len(expiring_contracts)}")
        
        return True
        
    except Exception as e:
        print(f"✗ Error sending email: {e}")
        return False

def main():
    """Main function"""
    print("=== Enhanced Vendor Contract Email Notifier ===\n")
    
    # Check if file exists
    if not os.path.exists(FILE_PATH):
        print(f"Error: File not found at {FILE_PATH}")
        return
    
    # Read contract data
    print("Reading contract file...")
    df = read_contract_file(FILE_PATH)
    
    if df is None:
        print("Failed to read contract file. Exiting...")
        return
    
    print(f"Successfully read {len(df)} records from contract file.\n")
    
    # Get expiring contracts
    print(f"Checking for contracts expiring within {DAYS_BEFORE_EXPIRY} days...")
    expiring_contracts = get_expiring_contracts(df)
    
    if expiring_contracts:
        print(f"\nFound {len(expiring_contracts)} contract(s) expiring soon:")
        for contract in expiring_contracts:
            print(f"  - {contract['vendor']}: {contract['days_remaining']} days remaining")
    else:
        print("No contracts found expiring within the specified timeframe.")
    
    # Send consolidated email
    print(f"\nSending consolidated email notification...")
    success = send_consolidated_email(expiring_contracts)
    
    if success:
        print("\n✓ Process completed successfully!")
    else:
        print("\n✗ Process completed with errors.")
    
    print("\nPress Enter to exit...")
    input()

if __name__ == "__main__":
    main()
