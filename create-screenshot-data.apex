// Create diverse, impressive test data for LinkedIn screenshots
List<Case> linkedInCases = new List<Case>{
    new Case(Subject='Global Customer - Dutch', Description='Wij hebben een kritieke productie-issue die onmiddellijke aandacht vereist. Onze applicatie is offline en dit heeft impact op duizenden gebruikers wereldwijd.', Origin='Phone', Priority='High'),
    new Case(Subject='Enterprise Client - German', Description='Unsere gesamte IT-Infrastruktur benötigt eine umfassende Sicherheitsanalyse nach dem kürzlichen Cyberangriff. Wir brauchen sofortige Expertenunterstützung.', Origin='Email', Priority='High'),
    new Case(Subject='International Corp - French', Description='Notre système de gestion des commandes connaît des dysfonctionnements majeurs. Nous perdons des ventes importantes chaque minute où ce problème persiste.', Origin='Web', Priority='High'),
    new Case(Subject='Multinational Firm - Spanish', Description='Necesitamos implementar una solución de recuperación ante desastres para nuestras operaciones críticas en América Latina. El tiempo es esencial.', Origin='Chat', Priority='Medium'),
    new Case(Subject='Tech Startup - English', Description='Our AI-powered application requires immediate performance optimization as we are experiencing 500% user growth and system bottlenecks are affecting user experience.', Origin='API', Priority='High')
};
insert linkedInCases;
System.debug('✅ Created impressive LinkedIn demo cases');
