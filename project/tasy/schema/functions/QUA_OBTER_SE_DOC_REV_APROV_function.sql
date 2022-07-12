-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_doc_rev_aprov ( nr_seq_documento_p bigint) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		varchar(255);


BEGIN
select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	qua_doc_revisao	a
where	a.nr_seq_doc	= nr_seq_documento_p
and	(a.dt_validacao IS NOT NULL AND a.dt_validacao::text <> '')
and	a.cd_revisao	=	(SELECT	max(x.cd_revisao)
				from	qua_doc_revisao	x
				where	x.nr_seq_doc = nr_seq_documento_p);

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_doc_rev_aprov ( nr_seq_documento_p bigint) FROM PUBLIC;

