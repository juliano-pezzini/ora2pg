-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_inicializar_lote_contabil ( nr_lote_contabil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
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
cd_tipo_lote_contabil_w			lote_contabil.cd_tipo_lote_contabil%type;


BEGIN
select	max(a.cd_tipo_lote_contabil)
into STRICT	cd_tipo_lote_contabil_w
from	lote_contabil	a
where	a.nr_lote_contabil	= nr_lote_contabil_p;

CALL philips_contabil_pck.inicializar_contabilizacao(cd_tipo_lote_contabil_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_inicializar_lote_contabil ( nr_lote_contabil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

