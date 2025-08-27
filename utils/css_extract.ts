// Import deno-dom for HTML parsing
import { DOMParser } from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";

// Function to extract CSS from <style> tags and save to a file
async function extractCss(inputHtmlFile: string, outputCssFile: string): Promise<void> {
  try {
    // Read the HTML file
    const htmlContent = await Deno.readTextFile(inputHtmlFile);

    // Parse HTML using deno-dom
    const parser = new DOMParser();
    const doc = parser.parseFromString(htmlContent, "text/html");
    if (!doc) {
      console.log("Failed to parse HTML file.");
      return;
    }

    // Find all <style> tags
    const styleTags = doc.getElementsByTagName("style");
    if (styleTags.length === 0) {
      console.log("No <style> tags found in the HTML file.");
      return;
    }

    // Extract CSS content from all <style> tags
    let cssContent = "";
    for (const style of styleTags) {
      if (style.textContent) {
        cssContent += style.textContent.trim() + "\n";
      }
    }

    // Write CSS to output file
    if (cssContent) {
      await Deno.writeTextFile(outputCssFile, cssContent);
      console.log(`CSS extracted successfully to ${outputCssFile}`);
    } else {
      console.log("No CSS content found in <style> tags.");
    }
  } catch (error) {
    console.error("Error extracting CSS:", error);
  }
}

// Main function to handle command-line arguments
function main() {
  const args = Deno.args;
  if (args.length !== 2) {
    console.error("Usage: deno run extract_css.ts <input.html> <output.css>");
    Deno.exit(1);
  }

  const inputFile = args[0];
  const outputFile = args[1];
  extractCss(inputFile, outputFile);
}

// Run the script
main();