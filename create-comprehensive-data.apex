System.debug('🧪 Creating comprehensive test data for impressive dashboard...');

// Create realistic enterprise test cases
List<Case> enterpriseTestCases = new List<Case>{
    
    // High-confidence Dutch cases
    new Case(
        Subject = 'Kritieke Server Storing',
        Description = 'Onze hoofdserver is volledig uitgevallen en alle werknemers kunnen niet meer werken. Dit is een noodsituatie die onmiddellijke aandacht vereist. Kunnen jullie direct een specialist sturen?',
        Origin = 'Phone',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Facturatie Probleem',
        Description = 'Wij hebben een factuur ontvangen die niet klopt met onze bestelling. Er staan producten op die wij nooit hebben besteld. Graag contact voor uitleg.',
        Origin = 'Email',
        Priority = 'Medium'
    ),
    
    // High-confidence German cases  
    new Case(
        Subject = 'Datenverlust nach Update',
        Description = 'Nach dem letzten Software-Update sind wichtige Kundendaten verschwunden. Wir brauchen sofortige Hilfe beim Wiederherstellen der Datenbank. Dies ist kritisch für unser Geschäft.',
        Origin = 'Web',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Lizenz Erneuerung erforderlich',
        Description = 'Unsere Softwarelizenz läuft nächste Woche ab und wir möchten sie erneuern. Können Sie uns die aktuellen Preise und Optionen mitteilen?',
        Origin = 'Chat',
        Priority = 'Medium'
    ),
    
    // High-confidence French cases
    new Case(
        Subject = 'Problème de sécurité urgent',
        Description = 'Nous avons détecté une tentative d intrusion dans notre système. Nous avons besoin d une analyse de sécurité complète et de recommandations immédiates.',
        Origin = 'Phone',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Formation équipe technique',
        Description = 'Notre équipe technique a besoin d une formation approfondie sur les nouvelles fonctionnalités. Pouvez-vous organiser une session de formation sur site?',
        Origin = 'Email',
        Priority = 'Low'
    ),
    
    // High-confidence Spanish cases
    new Case(
        Subject = 'Integración con sistema CRM',
        Description = 'Queremos integrar vuestra plataforma con nuestro sistema CRM existente. Necesitamos documentación técnica detallada y soporte durante la implementación.',
        Origin = 'Web',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Error en proceso de backup',
        Description = 'Nuestro proceso de backup automático está fallando desde hace tres días. Los logs muestran errores que no podemos interpretar. Necesitamos asistencia técnica urgente.',
        Origin = 'Chat',
        Priority = 'High'
    ),
    
    // High-confidence English cases
    new Case(
        Subject = 'API Rate Limiting Issues',
        Description = 'We are experiencing API rate limiting issues that are affecting our production environment. Our application is making legitimate requests but getting blocked. Please investigate.',
        Origin = 'Email',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Performance Optimization Consultation',
        Description = 'Our system performance has degraded significantly over the past month. We need a comprehensive performance analysis and optimization recommendations from your expert team.',
        Origin = 'Web',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Enterprise Security Audit',
        Description = 'We require a complete security audit of our implementation including penetration testing and compliance verification. When can we schedule this assessment?',
        Origin = 'Phone',
        Priority = 'Medium'
    ),
    
    // Additional variety cases
    new Case(
        Subject = 'Migratie naar nieuwe versie',
        Description = 'Wij willen migreren naar de nieuwste versie van jullie software. Wat zijn de vereisten en hoe lang duurt het migratieproces? Hebben jullie een projectmanager beschikbaar?',
        Origin = 'Email',
        Priority = 'Low'
    ),
    new Case(
        Subject = 'Disaster Recovery Plan',
        Description = 'Wir benötigen Unterstützung bei der Erstellung eines umfassenden Disaster Recovery Plans. Können Sie uns bei der Planung und Implementierung helfen?',
        Origin = 'Web',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Optimisation base de données',
        Description = 'Notre base de données devient très lente avec l augmentation du volume de données. Nous cherchons des solutions d optimisation et de mise à l échelle.',
        Origin = 'Chat',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Automatización de procesos',
        Description = 'Queremos automatizar varios procesos manuales en nuestro flujo de trabajo. ¿Pueden ayudarnos a identificar oportunidades de automatización y implementarlas?',
        Origin = 'Phone',
        Priority = 'Low'
    ),
    new Case(
        Subject = 'Multi-tenant Architecture Guidance',
        Description = 'We are planning to implement a multi-tenant architecture for our SaaS application. We need architectural guidance and best practices recommendations.',
        Origin = 'Email',
        Priority = 'Medium'
    )
};

System.debug('📝 Creating ' + enterpriseTestCases.size() + ' enterprise test cases...');
insert enterpriseTestCases;

System.debug('✅ Enterprise test cases created successfully!');

// Get updated dashboard data
Map<String, Object> dashboardData = RoutingDashboardController.getDashboardData();
System.debug('📊 Updated Dashboard Metrics:');
System.debug('  Total Cases: ' + dashboardData.get('totalCases'));
System.debug('  Success Rate: ' + dashboardData.get('successRate') + '%');
System.debug('  Queue Distribution: ' + dashboardData.get('queueBreakdown'));

System.debug('🎉 REFRESH YOUR DASHBOARD TO SEE IMPRESSIVE ENTERPRISE DATA!');
