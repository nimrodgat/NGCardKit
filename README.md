# NGCardsView
NGCardsView offers an easy way to implement scrollable "cards" UI. 

It takes care of the layout and scrolling logic so all you have to do is provide a view for every card.

![NGCardsView](https://github.com/nimrodgat/NGCardKit/blob/master/card-kit-demo.gif)

## Usage
Create an `NGCardsView` and set its data source (`NGCardsViewDataSource`) to provide the card views (remember to reuse card views when possible!). 

Set the delegate (`NGCardsViewDelegate`) to be notified about changes to the cards collection like scrolling or deletions.  

There's also an example project. In the example app, you can scroll the list of locations horizontally, tap on the next/previous card and swipe vertically to delete a card. 

## Installation
NGCardsView is available as part of `NGCardKit` in [Cocoapods](http://cocoapods.org) and requires iOS 9.0 or later.

Note:
`NGCardsView` handles scrolling & content insets for itself. If used in a view controller, make sure to set the following property to `NO`: 
`self.automaticallyAdjustsScrollViewInsets = NO;`

