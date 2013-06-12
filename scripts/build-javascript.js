#!/usr/bin/env node

/**
 * PassDeposit
 * Build configuration for javascript
 * 
 * @author Max Geissler
 */

'use strict';

var fs         = require('fs');
var path       = require('path');
var browserify = require('browserify');
var shim       = require('browserify-shim');
var uglifyjs   = require('uglify-js');

if (!process.argv[2])
{
	console.error('Missing output file.');
	process.exit(1);
}

var outFile = process.argv[2];
var pathMain = path.join(__dirname, '../src/js');
var pathLib = path.join(pathMain, '/lib');

var debug = process.argv[3] ? process.argv[3] === 'debug' : false;

var shimLibs =
{
	'sjcl':
	{
		path: path.join(pathLib, 'sjcl.js'),
		exports: 'sjcl'
	},
	'jquery':
	{
		path: path.join(pathLib, 'jquery.js'),
		exports: '$'
	},
	'jquery.totalStorage':
	{
		path: path.join(pathLib, 'jquery.total-storage.js'),
		exports: null,
		depends: { jquery: '$' }
	},
	'jquery.jGrowl':
	{
		path: path.join(pathLib, 'jquery.jgrowl.js'),
		exports: null,
		depends: { jquery: '$' }
	},
	'bootstrap':
	{
		path: path.join(pathLib, 'bootstrap.js'),
		exports: null,
		depends: { jquery: '$' }
	}
};

shim(browserify(), shimLibs)
.require(require.resolve(path.join(pathMain, 'passdeposit.js')), { entry: true })
.bundle({ debug: debug }, function (err, src)
{
	if (err)
	{
		var conserr = console.error(err);
		process.exit(1);
		return conserr;
	}
	
	// Minify
	var srcOut = debug ? src : uglifyjs.minify(src, { fromString: true }).code;
	
	// Add license
	srcOut = fs.readFileSync(path.join(pathMain, 'license.js')) + '\n' + srcOut;
	
	// Write output file
	fs.writeFileSync(outFile, srcOut);
	
	var msgSuccess = 'Build succeeded' + (debug ? ' (Debug)' : '');
	console.log(msgSuccess);
});