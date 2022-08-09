-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_1600_efd_icms ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_arquivo_w			varchar(4000);
ds_arquivo_compl_w		varchar(4000);
ds_linha_w			varchar(8000);
sep_w				varchar(1)	:= ds_separador_p;
nr_linha_w			bigint 	:= qt_linha_p;
nr_seq_registro_w		bigint 	:= nr_sequencia_p;
dt_fim_w			timestamp;

c_cartao CURSOR FOR
	SELECT	'1600' tp_registro,
		b.cd_cgc,
		coalesce(sum(CASE WHEN a.ie_tipo_cartao='C' THEN a.vl_transacao WHEN a.ie_tipo_cartao='D' THEN 0 END ),0) vl_cartao_credito,
		coalesce(sum(CASE WHEN a.ie_tipo_cartao='D' THEN a.vl_transacao WHEN a.ie_tipo_cartao='C' THEN 0 END ),0) vl_cartao_debito
	from	bandeira_cartao_cr	b,
		movto_cartao_cr		a
	where	b.nr_sequencia	= a.nr_seq_bandeira
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	a.dt_transacao between dt_inicio_p and dt_fim_w
	group by
		b.cd_cgc;

cartao	c_cartao%RowType;


BEGIN
dt_fim_w	:= fim_dia(dt_fim_p);


open c_cartao;
loop
fetch c_cartao into
	cartao;
EXIT WHEN NOT FOUND; /* apply on c_cartao */
	begin
	ds_linha_w	:= substr(	sep_w || cartao.tp_registro		||
					sep_w || cartao.cd_cgc			||
					sep_w || cartao.vl_cartao_credito	||
					sep_w || cartao.vl_cartao_debito	||
					sep_w,1,8000);

	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;

	insert into fis_efd_arquivo(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_controle_efd,
		nr_linha,
		cd_registro,
		ds_arquivo,
		ds_arquivo_compl)
	values (nr_seq_registro_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_controle_p,
		nr_linha_w,
		cartao.tp_registro,
		ds_arquivo_w,
		ds_arquivo_compl_w);
	end;
end loop;
close c_cartao;

commit;

qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_1600_efd_icms ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
