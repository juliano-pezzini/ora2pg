-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_dinamico_pck.get_tree () RETURNS SETOF TREE_T AS $body$
BEGIN
   if (current_setting('apap_dinamico_pck.tree_v_w')::tree_t.count > 0) then
	  for linha in current_setting('apap_dinamico_pck.tree_v_w')::tree_t.first..tree_v_w.last loop
		 if (current_setting('apap_dinamico_pck.tree_v_w')::tree_t.exists(linha)) then
			RETURN NEXT current_setting('apap_dinamico_pck.tree_v_w'::tree_t(linha));
		 end if;
	  end loop;
   end if;
   return;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION apap_dinamico_pck.get_tree () FROM PUBLIC;
