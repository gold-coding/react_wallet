import 'package:flutter/material.dart';
import 'package:reactor_wallet/utils/base_account.dart';
import 'package:reactor_wallet/utils/tracker.dart';
import 'package:reactor_wallet/utils/wallet_account.dart';
import 'package:solana/dto.dart' show Commitment;

Future<void> transactionIsBeingConfirmedDialog(
  context,
  Future future,
  Transaction transaction,
  TokenInfo tokenInfo,
  WalletAccount walletAccount,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: FutureBuilder(
            future: future,
            builder: (context, data) {
              if (data.hasData) {
                return FutureBuilder(
                  future: walletAccount.client.waitForSignatureStatus(
                    data.data as String,
                    status: Commitment.confirmed,
                  ),
                  builder: (context, data) {
                    return ListBody(
                      children: <Widget>[
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                Icons.task_alt_outlined,
                                color: Colors.green,
                                size: 35,
                              ),
                            ),
                            Text(
                              "Successfully sent ${transaction.ammount} ${tokenInfo.symbol} to",
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                transaction.destination,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    child: Center(
                      child: Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: CircularProgressIndicator(),
                          ),
                          Text("Sending transaction"),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () async {
              // Close the dialog
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}
