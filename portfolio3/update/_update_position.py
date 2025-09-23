def _update_position(active_client, transaction):
    # helper function to only be used inside create_transaction

    

    if transaction['type'] == 'CONTRIBUTION':
        if active_client['positions']:
            for position in active_client['positions']:                
                if position['symbol'] == transaction['symbol']:
                    position['shares'] += transaction['shares']
        else:
            position = {'id': transaction['id'],            
            'shares': round(transaction['shares'], 2),
            'symbol': transaction['symbol'],
            'name': transaction['name'],
            'avg_cost': transaction['trn_price']}

            active_client['positions'].append(position)    # or client['positions].append(position)

    return