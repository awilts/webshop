/**
 * @jest-environment jsdom
 */
import {fireEvent, getByPlaceholderText, render} from '@testing-library/svelte'
import Page from '../src/routes/index.svelte'

describe('render index.svelte', () => {

    it('renders successfully', async () => {
        const {getByText} = render(Page)

        expect(getByText('Create Order')).not.toBeNull()
    })


    it('renders successfully 2', async () => {
        const {getByText, getByPlaceholderText} = render(Page)


        const textField = getByPlaceholderText("Enter some product...");
        await fireEvent.input(textField, {target: {value: 'Teddy Bear'}})

        const button = getByText("Create Order");
        await fireEvent.click(button)
        //
        //
        // // expect(input.value).toBe('Teddy Bear')
        //
        // expect(getByText('Create Order')).not.toBeNull()
    })
})
