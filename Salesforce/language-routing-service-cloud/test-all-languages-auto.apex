System.debug('🧪 Testing AUTO-ROUTING for all languages...');

List<Case> testCases = new List<Case>{
    new Case(
        Subject = 'German Auto Test',
        Description = 'Ich brauche dringend Hilfe mit meinem defekten Produkt. Es funktioniert überhaupt nicht.',
        Origin = 'Email'
    ),
    new Case(
        Subject = 'French Auto Test', 
        Description = 'J ai une question très importante sur mon produit. Pouvez-vous m aider rapidement?',
        Origin = 'Web'
    ),
    new Case(
        Subject = 'Spanish Auto Test',
        Description = 'Necesito ayuda urgente con mi pedido. No puedo encontrar la información que necesito.',
        Origin = 'Phone'
    ),
    new Case(
        Subject = 'English Auto Test',
        Description = 'I need immediate assistance with my account settings and billing information please.',
        Origin = 'Chat'
    )
};

System.debug('📝 Creating ' + testCases.size() + ' test cases...');
insert testCases;

System.debug('🔍 Checking auto-routing results...');
List<Case> routedCases = [
    SELECT Id, Subject, OwnerId, Owner.Name 
    FROM Case 
    WHERE Id IN :testCases
    ORDER BY Subject
];

for (Case c : routedCases) {
    System.debug('✅ ' + c.Subject + ' → ' + c.Owner.Name);
}

System.debug('🎉 MULTI-LANGUAGE AUTO-ROUTING TEST COMPLETE!');
