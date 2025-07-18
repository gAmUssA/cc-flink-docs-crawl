#!/usr/bin/env python3
"""
Confluent Cloud Flink SQL Documentation Crawler
Downloads documentation from links.txt and generates llms.txt
"""

import requests
from bs4 import BeautifulSoup
import os
import time
from urllib.parse import urljoin, urlparse
import re
from typing import List, Dict, Tuple


class FlinkDocsCrawler:
    def __init__(self, links_file: str = "links.txt"):
        self.links_file = links_file
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        })
        self.crawled_content = []
        
    def load_links(self) -> List[str]:
        """Load URLs from links.txt file"""
        with open(self.links_file, 'r') as f:
            links = [line.strip() for line in f if line.strip() and not line.startswith('#')]
        return links
    
    def clean_text(self, text: str) -> str:
        """Clean and normalize text content"""
        # Remove excessive whitespace
        text = re.sub(r'\s+', ' ', text)
        # Remove empty lines
        text = re.sub(r'\n\s*\n', '\n', text)
        return text.strip()
    
    def extract_content(self, url: str) -> Dict[str, str]:
        """Extract relevant content from a documentation page"""
        try:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            
            # Remove script and style elements
            for script in soup(["script", "style", "nav", "header", "footer"]):
                script.decompose()
            
            # Extract title
            title = soup.find('title')
            title_text = title.get_text().strip() if title else urlparse(url).path
            
            # Extract main content (try common content selectors)
            content_selectors = [
                'main', 'article', '.content', '#content', '.main-content',
                '.documentation', '.docs-content', '.page-content'
            ]
            
            content = None
            for selector in content_selectors:
                content = soup.select_one(selector)
                if content:
                    break
            
            if not content:
                content = soup.find('body')
            
            if content:
                # Extract text content
                text_content = content.get_text()
                text_content = self.clean_text(text_content)
                
                # Extract code blocks specifically
                code_blocks = content.find_all(['pre', 'code'])
                code_content = []
                for code in code_blocks:
                    code_text = code.get_text().strip()
                    if code_text and len(code_text) > 10:  # Only meaningful code blocks
                        code_content.append(code_text)
                
                return {
                    'url': url,
                    'title': title_text,
                    'content': text_content,
                    'code_blocks': code_content
                }
            else:
                return {'url': url, 'title': title_text, 'content': '', 'code_blocks': []}
                
        except Exception as e:
            print(f"Error crawling {url}: {e}")
            return {'url': url, 'title': f"Error crawling {url}", 'content': '', 'code_blocks': []}
    
    def crawl_all_links(self) -> List[Dict[str, str]]:
        """Crawl all links from links.txt"""
        links = self.load_links()
        print(f"Found {len(links)} links to crawl")
        
        for i, url in enumerate(links, 1):
            print(f"Crawling ({i}/{len(links)}): {url}")
            content = self.extract_content(url)
            self.crawled_content.append(content)
            
            # Be respectful - add delay between requests
            time.sleep(1)
        
        return self.crawled_content
    
    def generate_llms_txt(self, output_file: str = "llms.txt") -> None:
        """Generate llms.txt file according to specification"""
        
        with open(output_file, 'w', encoding='utf-8') as f:
            # H1 Header (Required)
            f.write("# Confluent Cloud Flink SQL Documentation\n\n")
            
            # Optional blockquote description
            f.write("> Comprehensive documentation for Apache Flink SQL dialect used in Confluent Cloud. "
                   "This includes SQL syntax, functions, operators, and best practices for stream processing "
                   "with Flink SQL in Confluent Cloud.\n\n")
            
            # Overview section
            f.write("## Overview\n\n")
            f.write("This documentation covers:\n")
            f.write("- Flink SQL syntax and semantics\n")
            f.write("- Built-in functions and operators\n") 
            f.write("- Stream processing concepts\n")
            f.write("- Confluent Cloud specific features\n")
            f.write("- Best practices and examples\n\n")
            
            # Main documentation links
            f.write("## Core Documentation\n\n")
            
            for content in self.crawled_content:
                if content['content']:
                    # Create a brief description from the first few sentences
                    description = content['content'][:200].replace('\n', ' ').strip()
                    if len(description) == 200:
                        description += "..."
                    
                    f.write(f"- [{content['title']}]({content['url']}): {description}\n")
            
            # Content section with full text
            f.write("\n## Full Documentation Content\n\n")
            
            for content in self.crawled_content:
                if content['content']:
                    f.write(f"### {content['title']}\n")
                    f.write(f"Source: {content['url']}\n\n")
                    f.write(content['content'])
                    f.write("\n\n")
                    
                    # Include code blocks separately for better context
                    if content['code_blocks']:
                        f.write("#### Code Examples\n\n")
                        for code_block in content['code_blocks']:
                            f.write("```sql\n")
                            f.write(code_block)
                            f.write("\n```\n\n")
                    
                    f.write("---\n\n")
        
        print(f"Generated {output_file}")
    
    def run(self) -> None:
        """Main method to run the crawler"""
        print("Starting Confluent Cloud Flink SQL Documentation Crawler")
        
        # Check if links file exists
        if not os.path.exists(self.links_file):
            print(f"Error: {self.links_file} not found")
            return
        
        # Crawl all documentation
        self.crawl_all_links()
        
        # Generate llms.txt
        self.generate_llms_txt()
        
        print("Crawling completed successfully!")


if __name__ == "__main__":
    crawler = FlinkDocsCrawler()
    crawler.run()