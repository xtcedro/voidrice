import { JSDOM } from 'jsdom';
import * as fs from 'fs/promises';
import * as path from 'path';

// Function to extract CSS from <style> tags and save to main.css
async function extractCss(inputHtmlFile: string, outputCssFile: string): Promise<void> {
  try {
    // Read the HTML file
    const htmlContent = await fs.readFile(inputHtmlFile, 'utf-8');

    // Parse HTML using JSDOM
    const dom = new JSDOM(htmlContent);
    const document = dom.window.document;

    // Find all <style> tags
    const styleTags = document.querySelectorAll('style');
    if (styleTags.length === 0) {
      console.log('No <style> tags found in the HTML file.');
      return;
    }

    // Extract CSS content from all <style> tags
    let cssContent = '';
    styleTags.forEach((style) => {
      if (style.textContent) {
        cssContent += style.textContent.trim() + '\n';
      }
    });

    // Write CSS to output file
    if (cssContent) {
      await fs.writeFile(outputCssFile, cssContent, 'utf-8');
      console.log(`CSS extracted successfully to ${outputCssFile}`);
    } else {
      console.log('No CSS content found in <style> tags.');
    }
  } catch (error) {
    console.error('Error extracting CSS:', error);
  }
}

// Main function to handle command-line arguments
async function main() {
  const args = process.argv.slice(2);
  if (args.length !== 2) {
    console.error('Usage: ts-node extract_css.ts <input.html> <output.css>');
    process.exit(1);
  }

  const inputFile = path.resolve(args[0]);
  const outputFile = path.resolve(args[1]);
  await extractCss(inputFile, outputFile);
}

// Run the script
main();