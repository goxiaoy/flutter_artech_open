import 'package:flutter/material.dart';

import './loading_gif.dart';

const Color _kColorBegin = Color.fromRGBO(186, 125, 251, 1);
const Color _kColorEnd = Color.fromRGBO(123, 13, 238, 1);

/*
Please use ArtechRaised button
* */
@deprecated
class LoadableRaisedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool loading;
  final double? minWidth;

  const LoadableRaisedButton(
      {required this.text,
      this.loading = false,
      this.minWidth,
      this.onPressed});

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth ?? 150,
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                if (!loading) {
                  //protect
                  onPressed!();
                }
              },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
            ),
            padding: EdgeInsets.all(0.0)),
        child: Ink(
          decoration: _enabled
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_kColorBegin, _kColorEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(50.0))
              : null,
          child: Container(
            alignment: Alignment.center,
            constraints:
                BoxConstraints(maxWidth: minWidth ?? 150, minHeight: 40),
            child: loading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoadingGif(),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
