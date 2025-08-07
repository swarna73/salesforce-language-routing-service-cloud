import pandas as pd
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime
import os
import sys

# Configuration
FILE_PATH = r"/Users/swarnalathaswaminathan/Documents/Notify_Contract_expiry/Contract.xls"
RECIPIENTS = ["swarnalatha73@gmail.com", "autotestuser7383@gmail.com"]

# Email configuration - UPDATE THESE WITH YOUR EMAIL SETTINGS
SMTP_SERVER = "smtp.gmail.com"  # Change this to your SMTP server
SMTP_PORT = 587  # Standard port for TLS
SENDER_EMAIL = "swarnalatha73@gmail.com"  # UPDATE: Your email address
SENDER_PASSWORD = "uijs akob bhhn vuoz"  # UPDATE: Your email password or app password

def read_excel_file(file_path):
    """Read the Excel file and extract notice dates"""
    try:
        # Read the Excel file
        df = pd.read_excel(file_path, engine='xlrd')
        print(f"Successfully read Excel file: {file_path}")
        
        # Check if 'Notice date' column exists (case-insensitive)
        notice_date_column = None
        for col in df.columns:
            if col.lower().strip() == 'notice date':
                notice_date_column = col
                break
        
        if notice_date_column is None:
            print("Error: 'Notice date' column not found in the Excel file")
            print(f"Available columns: {list(df.columns)}")
            return None
        
        # Extract notice dates
        notice_dates = df[notice_date_column].dropna()
        return notice_dates
        
    except FileNotFoundError:
        print(f"Error: File not found at {file_path}")
        return None
    except Exception as e:
        print(f"Error reading Excel file: {str(e)}")
        return None

def send_email(notice_date, recipients):
    """Send email notification about vendor expiration"""
    try:
        # Format the date
        if isinstance(notice_date, pd.Timestamp):
            formatted_date = notice_date.strftime("%Y-%m-%d")
        else:
            formatted_date = str(notice_date)
        
        # Create message
        msg = MIMEMultipart()
        msg['From'] = SENDER_EMAIL
        msg['To'] = ', '.join(recipients)
        msg['Subject'] = f"Vendor Contract Expiration Notice - {formatted_date}"
        
        # Email body
        body = f"Vendor expiring on {formatted_date}"
        msg.attach(MIMEText(body, 'plain'))
        
        # Send email
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()  # Enable TLS encryption
            server.login(SENDER_EMAIL, SENDER_PASSWORD)
            server.send_message(msg)
        
        print(f"Email sent successfully for notice date: {formatted_date}")
        return True
        
    except Exception as e:
        print(f"Error sending email: {str(e)}")
        return False

def main():
    """Main function to read Excel and send emails"""
    print("=== Vendor Contract Email Notifier ===\n")
    
    # Check if email credentials are configured
    if SENDER_EMAIL == "your_email@gmail.com" or SENDER_PASSWORD == "your_app_password":
        print("ERROR: Please update the email configuration in the script")
        print("Update SENDER_EMAIL and SENDER_PASSWORD with your actual credentials")
        print("\nFor Gmail users:")
        print("1. Enable 2-factor authentication")
        print("2. Generate an app password at: https://myaccount.google.com/apppasswords")
        print("3. Use the app password instead of your regular password")
        return
    
    # Read Excel file
    notice_dates = read_excel_file(FILE_PATH)
    
    if notice_dates is None:
        print("Failed to read Excel file. Exiting...")
        return
    
    print(f"\nFound {len(notice_dates)} notice date(s) in the Excel file")
    
    # Send email for each notice date
    success_count = 0
    for idx, notice_date in enumerate(notice_dates, 1):
        print(f"\nProcessing notice date {idx}/{len(notice_dates)}: {notice_date}")
        if send_email(notice_date, RECIPIENTS):
            success_count += 1
    
    print(f"\n=== Summary ===")
    print(f"Total notice dates processed: {len(notice_dates)}")
    print(f"Emails sent successfully: {success_count}")
    print(f"Failed: {len(notice_dates) - success_count}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nProcess interrupted by user")
    except Exception as e:
        print(f"\nUnexpected error: {str(e)}")
    
    input("\nPress Enter to exit...")
