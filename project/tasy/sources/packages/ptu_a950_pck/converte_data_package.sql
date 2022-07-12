-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ptu_a950_pck.converte_data ( data_p text) RETURNS timestamp AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Converte a data no formato varchar de forma padrao.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[ ]  Objetos do dicionario [X] Tasy (Delphi/Java) [ X] Portal [ X]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN

if (coalesce(data_p, 'X') != 'X') then
	return to_date(data_p, 'yyyy-mm-dd');
else
	return null;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_a950_pck.converte_data ( data_p text) FROM PUBLIC;
