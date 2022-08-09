-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_regra_lanc_auto_ame ( nr_seq_contrato_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


cd_cgc_estipulante_w		pls_contrato.cd_cgc_estipulante%type;
nr_seq_empresa_w		pls_ame_empresa.nr_sequencia%type;
nr_seq_regra_ger_dest_w		pls_ame_regra_ger_dest.nr_sequencia%type;
nr_seq_regra_ger_arq_w		pls_ame_regra_ger_arq.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_regra_ame
	from	pls_regra_lanc_automatico
	where	ie_evento = 15;

C02 CURSOR(	nr_seq_regra_lanc_aut_pc	bigint) FOR
	SELECT	nr_sequencia
	from	pls_ame_regra_ger_arq
	where	nr_seq_regra_lanc_aut	= nr_seq_regra_lanc_aut_pc;
BEGIN

select	max(cd_cgc_estipulante)
into STRICT	cd_cgc_estipulante_w
from	pls_contrato
where	nr_sequencia	= nr_seq_contrato_p;

if (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') then
	for r_c01_w in C01 loop
		begin

		select	max(nr_sequencia)
		into STRICT	nr_seq_empresa_w
		from	pls_ame_empresa
		where	cd_cgc	= cd_cgc_estipulante_w;

		if (coalesce(nr_seq_empresa_w::text, '') = '') then
			select	nextval('pls_ame_empresa_seq')
			into STRICT	nr_seq_empresa_w
			;

			insert	into	pls_ame_empresa(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_cgc,
					ie_enviar_email)
				values (	nr_seq_empresa_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_cgc_estipulante_w,
					'N');
		end if;

		select	nextval('pls_ame_regra_ger_dest_seq')
		into STRICT	nr_seq_regra_ger_dest_w
		;

		insert	into	pls_ame_regra_ger_dest(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_regra_geracao,
				nr_seq_ame_empresa)
			values (	nr_seq_regra_ger_dest_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				r_c01_w.nr_seq_regra_ame,
				nr_seq_empresa_w);

		for r_c02_w in C02(r_c01_w.nr_sequencia) loop
			begin
			select	nextval('pls_ame_regra_ger_arq_seq')
			into STRICT	nr_seq_regra_ger_arq_w
			;

			insert	into	pls_ame_regra_ger_arq(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_regra_ger_dest,
					ds_caminho_arquivo,
					nm_arquivo,
					qt_max_titular,
					qt_max_linha,
					ie_nm_arquivo_div,
					nm_objeto_geracao)
				(SELECT	nr_seq_regra_ger_arq_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_regra_ger_dest_w,
					ds_caminho_arquivo,
					nm_arquivo,
					qt_max_titular,
					qt_max_linha,
					ie_nm_arquivo_div,
					nm_objeto_geracao
				from	pls_ame_regra_ger_arq
				where	nr_sequencia	= r_c02_w.nr_sequencia);

			insert	into	pls_ame_regra_ger_item(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_regra_ger_arq,
					ie_regra_excecao,
					ie_tipo_item_mens,
					ie_consid_zerado,
					nr_seq_tipo_lanc)
				(SELECT	nextval('pls_ame_regra_ger_item_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_regra_ger_arq_w,
					ie_regra_excecao,
					ie_tipo_item_mens,
					ie_consid_zerado,
					nr_seq_tipo_lanc
				from	pls_ame_regra_ger_item
				where	nr_seq_regra_ger_arq	= r_c02_w.nr_sequencia);
			end;
		end loop; --C02
		end;
	end loop; --C01
end if;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_lanc_auto_ame ( nr_seq_contrato_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
