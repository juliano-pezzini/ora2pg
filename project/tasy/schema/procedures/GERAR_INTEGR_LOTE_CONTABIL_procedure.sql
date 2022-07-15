-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_integr_lote_contabil ( nr_lote_contabil_p bigint, ie_integracao_p bigint, ds_filename_p text, cd_interface_p bigint, ie_tipo_integracao_p text, nr_seq_proj_xml_p bigint, nm_usuario_p text, dt_interface_p timestamp default null) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------

Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cont_w			bigint;
nr_sequencia_w		bigint;


BEGIN
select	max(ie_integracao)
into STRICT	nr_sequencia_w
from	integracao_lote_contabil
where	nr_lote_contabil	= nr_lote_contabil_p;

nr_sequencia_w	:= coalesce(nr_sequencia_w, 0);


nr_sequencia_w	:= nr_sequencia_w + 1;



insert into integracao_lote_contabil(nr_lote_contabil,
	ie_integracao,
	ds_filename,
	dt_atualizacao,
	nm_usuario,
	dt_interface,
	nm_usuario_interface,
	dt_estorno,
	nm_usuario_estorno,
	ds_motivo_estorno,
	cd_interface,
	ie_tipo_integracao,
	nr_seq_proj_xml)
values (nr_lote_contabil_p,
	nr_sequencia_w,
	ds_filename_p,
	clock_timestamp(),
	nm_usuario_p,
	coalesce(CASE WHEN coalesce(cd_interface_p,0)=0 THEN null  ELSE clock_timestamp() END ,dt_interface_p),
	nm_usuario_p,
	null,
	'',
	'',
	CASE WHEN cd_interface_p=0 THEN null  ELSE cd_interface_p END ,
	ie_tipo_integracao_p,
	nr_seq_proj_xml_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_integr_lote_contabil ( nr_lote_contabil_p bigint, ie_integracao_p bigint, ds_filename_p text, cd_interface_p bigint, ie_tipo_integracao_p text, nr_seq_proj_xml_p bigint, nm_usuario_p text, dt_interface_p timestamp default null) FROM PUBLIC;

