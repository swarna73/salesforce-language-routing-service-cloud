System.debug('🧪 Creating comprehensive test data for dashboard...');

// Create diverse test cases across all languages
List<Case> comprehensiveTestCases = new List<Case>{
    
    // Dutch Cases
    new Case(
        Subject = 'Technische Ondersteuning - Server Probleem',
        Description = 'Onze server heeft problemen en we kunnen niet inloggen. Dit is een kritieke situatie voor ons bedrijf. Kunnen jullie ons zo snel mogelijk helpen?',
        Origin = 'Email',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Factuur Vraag - Betaling',
        Description = 'Ik heb een vraag over mijn laatste factuur. Er staat een bedrag op dat ik niet herken. Graag uitleg.',
        Origin = 'Phone',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Product Defect - Garantie Claim',
        Description = 'Het product dat ik vorige maand heb gekocht werkt niet meer. Ik wil graag gebruik maken van de garantie.',
        Origin = 'Web',
        Priority = 'Medium'
    ),
    
    // German Cases
    new Case(
        Subject = 'Dringende Software Installation',
        Description = 'Wir benötigen sofortige Hilfe bei der Installation der neuen Software. Unser Team kann nicht arbeiten ohne diese Anwendung.',
        Origin = 'Chat',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Benutzer Account Probleme',
        Description = 'Mehrere Benutzer können sich nicht in ihre Konten einloggen. Das Problem besteht seit heute Morgen.',
        Origin = 'Email',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Lieferung Verspätung',
        Description = 'Unsere Bestellung sollte letzte Woche ankommen, aber wir haben noch nichts erhalten. Können Sie den Status prüfen?',
        Origin = 'Phone',
        Priority = 'Medium'
    ),
    
    // French Cases
    new Case(
        Subject = 'Problème de Configuration Réseau',
        Description = 'Nous avons des difficultés avec la configuration de notre réseau. Les connexions sont très lentes et instables.',
        Origin = 'Web',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Formation Utilisateur Demandée',
        Description = 'Notre équipe a besoin d une formation sur les nouvelles fonctionnalités. Pouvez-vous organiser une session?',
        Origin = 'Email',
        Priority = 'Low'
    ),
    new Case(
        Subject = 'Mise à jour Logiciel',
        Description = 'Nous voulons mettre à jour notre logiciel vers la dernière version. Quelles sont les étapes à suivre?',
        Origin = 'Chat',
        Priority = 'Medium'
    ),
    
    // Spanish Cases
    new Case(
        Subject = 'Error de Base de Datos Crítico',
        Description = 'Tenemos un error crítico en nuestra base de datos que está afectando todas nuestras operaciones. Necesitamos ayuda inmediata.',
        Origin = 'Phone',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Integración de Sistemas',
        Description = 'Queremos integrar nuestro sistema CRM con su plataforma. ¿Pueden proporcionar documentación técnica y soporte?',
        Origin = 'Email',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Capacitación para Administradores',
        Description = 'Necesitamos capacitación especializada para nuestros administradores de sistema. ¿Qué opciones tienen disponibles?',
        Origin = 'Web',
        Priority = 'Low'
    ),
    
    // English Cases
    new Case(
        Subject = 'API Integration Support Needed',
        Description = 'We are trying to integrate our existing systems with your API but encountering authentication errors. Can you provide technical assistance?',
        Origin = 'Chat',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Performance Optimization Request',
        Description = 'Our application is running slower than expected. We need help optimizing performance and identifying bottlenecks.',
        Origin = 'Email',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Security Assessment Required',
        Description = 'We need a comprehensive security assessment of our current setup. Can you schedule a review with your security team?',
        Origin = 'Web',
        Priority = 'High'
    ),
    new Case(
        Subject = 'License Renewal Question',
        Description = 'Our license is expiring next month and we want to discuss renewal options and potential upgrades.',
        Origin = 'Phone',
        Priority = 'Medium'
    ),
    
    // Mixed complexity cases
    new Case(
        Subject = 'Implementatie van nieuwe features',
        Description = 'We willen graag de nieuwe features implementeren in onze productie omgeving. Wat zijn de beste practices hiervoor?',
        Origin = 'Email',
        Priority = 'Low'
    ),
    new Case(
        Subject = 'Backup und Recovery Strategie',
        Description = 'Wir brauchen eine umfassende Backup- und Recovery-Strategie für unsere kritischen Daten. Können Sie uns beraten?',
        Origin = 'Web',
        Priority = 'Medium'
    ),
    new Case(
        Subject = 'Optimisation des performances',
        Description = 'Notre système devient de plus en plus lent. Nous aimerions une analyse complète des performances et des recommandations.',
        Origin = 'Chat',
        Priority = 'High'
    ),
    new Case(
        Subject = 'Migración de datos compleja',
        Description = 'Tenemos que migrar una gran cantidad de datos desde nuestro sistema legacy. ¿Pueden ayudarnos con el proceso?',
        Origin = 'Phone',
        Priority = 'High'
    )
};

System.debug('📝 Creating ' + comprehensiveTestCases.size() + ' comprehensive test cases...');
insert comprehensiveTestCases;

System.debug('✅ Test cases created successfully!');
System.debug('📊 Dashboard should now show rich data with:');
System.debug('  - Multiple languages detected');
System.debug('  - Various queue distributions'); 
System.debug('  - Different priorities and origins');
System.debug('  - Higher case volumes');

System.debug('🎉 REFRESH YOUR DASHBOARD TO SEE THE RESULTS!');
