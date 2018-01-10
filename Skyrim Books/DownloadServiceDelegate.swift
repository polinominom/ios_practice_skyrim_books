//
//  DownloadServiceDelegate.swift
//  Skyrim Books
//
//  Created by Çağrı Yıldız on 15/07/2017.
//  Copyright © 2017 Çağrı Yıldız. All rights reserved.
//

import Foundation

protocol DownloadServiceDelegate
{
    func downloadsDidFinished()
    func startedContentDownload(index: Int)
    func startedTitleDownload(index: Int)
    func oneDownloadFinished(index: Int)
    
    func startedChapteredContentDownload(index: Int, chapterCount: Int)
    func didFinishedChapterContentDownload(index: Int)
    
    func startedUnchapteredContentDownload(index: Int)
    func didFinishedUnchapteredContentDownload(index: Int)
}
