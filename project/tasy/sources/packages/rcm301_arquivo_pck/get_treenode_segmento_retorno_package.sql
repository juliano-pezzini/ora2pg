-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION rcm301_arquivo_pck.get_treenode_segmento_retorno (ie_segmento_p text) RETURNS bigint AS $body$
DECLARE


nr_tree_node_w	bigint;


BEGIN

if (ie_segmento_p = 'AUF' ) then
	nr_tree_node_w := 1044326;
elsif (ie_segmento_p = 'BDG' ) then
	nr_tree_node_w := 1044331;
elsif (ie_segmento_p = 'CUX' ) then
	nr_tree_node_w := 1044336;
elsif (ie_segmento_p = 'DAU' ) then
	nr_tree_node_w := 1044341;
elsif (ie_segmento_p = 'DPV' ) then
	nr_tree_node_w := 1044346;
elsif (ie_segmento_p = 'EAD' ) then
	nr_tree_node_w := 1044351;
elsif (ie_segmento_p = 'EBG' ) then
	nr_tree_node_w := 1044356;
elsif (ie_segmento_p = 'ENA' ) then
	nr_tree_node_w := 1044361;
elsif (ie_segmento_p = 'ENT' ) then
	nr_tree_node_w := 1044366;
elsif (ie_segmento_p = 'ETL' ) then
	nr_tree_node_w := 1044373;
elsif (ie_segmento_p = 'EZV' ) then
	nr_tree_node_w := 1044378;
elsif (ie_segmento_p = 'FAB' ) then
	nr_tree_node_w := 1044384;
elsif (ie_segmento_p = 'FHL' ) then
	nr_tree_node_w := 1044389;
elsif (ie_segmento_p = 'FKT' ) then
	nr_tree_node_w := 1044394;
elsif (ie_segmento_p = 'INV' ) then
	nr_tree_node_w := 1044399;
elsif (ie_segmento_p = 'KOS' ) then
	nr_tree_node_w := 1044404;
elsif (ie_segmento_p = 'LEI' ) then
	nr_tree_node_w := 1044409;
elsif (ie_segmento_p = 'NAD' ) then
	nr_tree_node_w := 1044414;
elsif (ie_segmento_p = 'NDG' ) then
	nr_tree_node_w := 1044419;
elsif (ie_segmento_p = 'PNV' ) then
	nr_tree_node_w := 1094105;
elsif (ie_segmento_p = 'PRZ' ) then
	nr_tree_node_w := 1044426;
elsif (ie_segmento_p = 'PVK' ) then
	nr_tree_node_w := 1094110;
elsif (ie_segmento_p = 'PVT' ) then
	nr_tree_node_w := 1044437;
elsif (ie_segmento_p = 'PVV' ) then
	nr_tree_node_w := 1044431;
elsif (ie_segmento_p = 'RBG' ) then
	nr_tree_node_w := 1044443;
elsif (ie_segmento_p = 'REC' ) then
	nr_tree_node_w := 1044448;
elsif (ie_segmento_p = 'RED' ) then
	nr_tree_node_w := 1044453;
elsif (ie_segmento_p = 'RZA' ) then
	nr_tree_node_w := 1044458;
elsif (ie_segmento_p = 'TXT' ) then
	nr_tree_node_w := 1044463;
elsif (ie_segmento_p = 'UNH' ) then
	nr_tree_node_w := 1044321;
elsif (ie_segmento_p = 'UNT' ) then
	nr_tree_node_w := 1044316;
elsif (ie_segmento_p = 'UWD' ) then
	nr_tree_node_w := 1044468;
elsif (ie_segmento_p = 'ZLG' ) then
	nr_tree_node_w := 1044473;
elsif (ie_segmento_p = 'ZPR' ) then
	nr_tree_node_w := 1044478;
end if;

return	nr_tree_node_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION rcm301_arquivo_pck.get_treenode_segmento_retorno (ie_segmento_p text) FROM PUBLIC;