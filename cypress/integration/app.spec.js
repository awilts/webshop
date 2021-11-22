describe('webshop', () => {

    beforeEach(() => {
        cy.intercept('POST', "/api/orders", {fixture: 'orders' })
        cy.intercept('GET', "/api/pickjobs?orderId=qvuW4yeE9nZbdZHJwxqhV9", {fixture: 'pickjobs' })
    })

    it('visits the webshop', () => {
        cy.visit('http://localhost:3000')
        expect(cy.contains('Create Order')).to.not.be.null
    })

    it('creates a new order', () => {
        cy.visit('http://localhost:3000')

        cy.get('input').click().wait(200).type('Teddy Bear')
        cy.contains('Create Order').click()

        // contains expected order id
        cy.contains('qvuW4yeE9nZbdZHJwxqhV9')
    })

    it('receives pickjob after creating a new order', () => {
        cy.visit('http://localhost:3000')

        cy.get('input').click().wait(200).type('Teddy Bear')
        cy.contains('Create Order').click()

        // contains expected pickjob id
        cy.contains('tSvif9SJmgE9hsRNykzWKz')
    })

    it('receives pickjob after several retries', () => {
        cy.intercept('GET', "/api/pickjobs?orderId=qvuW4yeE9nZbdZHJwxqhV9", {fixture: 'pickjobs_empty' }).as('get_empty_pickjobs')
        cy.visit('http://localhost:3000')

        cy.get('input').click().wait(200).type('Teddy Bear')
        cy.contains('Create Order').click()
        cy.wait('@get_empty_pickjobs')
        cy.wait('@get_empty_pickjobs')
        cy.wait('@get_empty_pickjobs')
        cy.contains('tSvif9SJmgE9hsRNykzWKz').should('not.exist');

        cy.intercept('GET', "/api/pickjobs?orderId=qvuW4yeE9nZbdZHJwxqhV9", {fixture: 'pickjobs' })
        // contains expected pickjob id
        cy.contains('tSvif9SJmgE9hsRNykzWKz')
    })
})