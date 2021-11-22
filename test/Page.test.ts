/**
 * @jest-environment jsdom
 */
import { fireEvent, render } from '@testing-library/svelte'
import Page from '../src/routes/index.svelte'

describe('render index.svelte', () => {

    it('renders successfully', async () => {
        const { getByText, getByTestId } = render(Page)

        expect(getByText('Create Order')).not.toBeNull()
    })
})
