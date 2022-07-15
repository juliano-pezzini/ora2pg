-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE encaminhar_comunicacao_interna ( nr_seq_origem_p bigint, nm_usuario_p text, nr_seq_nova_p INOUT bigint) AS $body$
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
nr_seq_comunic_w		bigint;
ds_titulo_w			varchar(255);
ds_comunic_w			varchar(32000);
nm_usuario_origem_w		varchar(15);
ie_geral_w			varchar(1);
ie_gerencial_w			varchar(1);
nr_seq_classif_w		bigint;
cd_estab_destino_w		smallint;
ds_setor_adicional_w		varchar(2000);


BEGIN
select	ds_titulo,
	nm_usuario,
	ie_geral,
	ie_gerencial,
	nr_seq_classif,
	cd_estab_destino,
	ds_setor_adicional
into STRICT	ds_titulo_w,
	nm_usuario_origem_w,
	ie_geral_w,
	ie_gerencial_w,
	nr_seq_classif_w,
	cd_estab_destino_w,
	ds_setor_adicional_w
from	comunic_interna
where	nr_sequencia	= nr_seq_origem_p;

begin
select	ds_comunicado
into STRICT	ds_comunic_w
from	comunic_interna
where	nr_sequencia	= nr_seq_origem_p;
exception
when others then
	ds_comunic_w	:= wheb_mensagem_pck.get_texto(298622);
end;

select	nextval('comunic_interna_seq')
into STRICT	nr_seq_comunic_w
;

insert into comunic_interna(dt_comunicado,
	ds_titulo,
	ds_comunicado,
	nm_usuario,
	dt_atualizacao,
	ie_geral,
	nr_sequencia,
	ie_gerencial,
	nr_seq_classif,
	cd_estab_destino)
values (clock_timestamp(),
	substr(wheb_mensagem_pck.get_texto(298623, 'DS_TITULO=' || ds_titulo_w),1,254),
	ds_comunic_w,
	nm_usuario_p,
	clock_timestamp(),
	'N',
	nr_seq_comunic_w,
	ie_gerencial_w,
	nr_seq_classif_w,
	cd_estab_destino_w);

insert into comunic_interna_arq(nr_sequencia,
	nr_seq_comunic,
	nm_usuario,
	dt_atualizacao,
	ds_arquivo)
SELECT	nextval('comunic_interna_arq_seq'),
	nr_seq_comunic_w,
	nm_usuario_p,
	clock_timestamp(),
	ds_arquivo
from	comunic_interna_arq
where	nr_seq_comunic	= nr_seq_origem_p;

nr_seq_nova_p	:= nr_seq_comunic_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE encaminhar_comunicacao_interna ( nr_seq_origem_p bigint, nm_usuario_p text, nr_seq_nova_p INOUT bigint) FROM PUBLIC;

