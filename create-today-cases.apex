System.debug('🧪 Creating fresh test cases for today...');

// Create new cases for today to populate the dashboard
List<Case> todayCases = new List<Case>{
    new Case(
        Subject = 'Today - Critical Dutch System Issue',
        Description = 'Onze hoofdserver is volledig uitgevallen en alle werknemers kunnen niet meer werken. Dit is een noodsituatie die onmiddellijke aandacht vereist.',
        Origin = 'Phone',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Today - German Database Emergency',
        Description = 'Unsere Produktionsdatenbank ist komplett ausgefallen. Alle Geschäftsprozesse sind betroffen und wir verlieren Millionen pro Stunde.',
        Origin = 'Email',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Today - French Security Breach',
        Description = 'Nous avons détecté une intrusion majeure dans notre système. Nous avons besoin d une intervention immédiate pour sécuriser nos données.',
        Origin = 'Web',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Today - Spanish API Integration',
        Description = 'Necesitamos integrar urgentemente nuestro sistema CRM con la nueva plataforma. El lanzamiento es mañana y necesitamos soporte técnico.',
        Origin = 'Chat',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Today - English Performance Crisis',
        Description = 'Our production system is experiencing severe performance degradation affecting millions of users worldwide. Immediate optimization required.',
        Origin = 'API',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Today - Dutch Billing Question',
        Description = 'Wij hebben een vraag over onze maandelijkse factuur. Er staan kosten op die wij niet herkennen.',
        Origin = 'Email',
        Priority = 'Low'
    ),
    new Case(
        Subject = 'Today - German License Renewal',
        Description = 'Unsere Softwarelizenz läuft nächste Woche ab und wir möchten sie für unser gesamtes Unternehmen erneuern.',
        Origin = 'Phone',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Today - French Training Request',
        Description = 'Notre équipe technique a besoin d une formation approfondie sur les nouvelles fonctionnalités de sécurité.',
        Origin = 'Web',
        Priority = 'Low'
    ),
    new Case(
        Subject = 'Today - Spanish Migration Support',
        Description = 'Queremos migrar todos nuestros datos a la nueva plataforma cloud. Necesitamos un plan detallado y soporte durante el proceso.',
        Origin = 'Chat',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Today - English Architecture Review',
        Description = 'We need a comprehensive architecture review for our multi-tenant SaaS application to ensure scalability for 10x growth.',
        Origin = 'Email',
        Priority = 'Medium'
    )
};

System.debug('📝 Creating ' + todayCases.size() + ' cases for today...');
insert todayCases;

System.debug('✅ Today\'s test cases created successfully!');

// Test the dashboard data immediately
Map<String, Object> dashboardData = RoutingDashboardController.getDashboardData();
System.debug('📊 Updated Dashboard Metrics:');
System.debug('  Total Cases: ' + dashboardData.get('totalCases'));
System.debug('  Success Rate: ' + dashboardData.get('successRate') + '%');

System.debug('🎉 REFRESH YOUR DASHBOARD TO SEE TODAY\'S DATA!');
