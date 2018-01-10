//
//  BookshellTableViewCell.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 15/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import UIKit

class BookshellTableViewCell: UITableViewCell
{
    // PROPERTIES
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
