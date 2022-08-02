-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_dados_prest_inter ( nr_seq_lote_p text, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


cd_cgc_cpf_w			varchar(14);
ds_razao_social_w		varchar(60);
ie_tipo_w			smallint;
cd_municipio_ibge_w		integer;
ie_contratacao_w		varchar(1);
dt_contratacao_w		timestamp;
cd_cnes_w			integer;
dt_vinculo_w			timestamp;
cd_classificacao_w		smallint;
cd_ans_int_w			integer;
ie_disponibilidade_serv_w	varchar(1);
ie_urgencia_emergencia_w	varchar(1);
nr_seq_prest_inter_w		pls_prestador_intercambio.nr_sequencia%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_interc_movto_w		pls_prestador_interc_movto.nr_sequencia%type;
nr_seq_lote_w			pls_lote_prestador_interc.nr_sequencia%type;
ds_erro_w			varchar(4000);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_prestador_interc_movto
	where	nr_seq_lote = nr_seq_lote_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_interc_movto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_p := '';

	select 	nr_sequencia,
		nr_seq_lote,
		trim(both cd_cgc_cpf),
		trim(both ds_razao_social),
		ie_tipo,
		rpad(cd_municipio_ibge,6,'0'),
		ie_contratacao,
		dt_contratacao,
		cd_cnes,
		dt_vinculo,
		cd_classificacao,
		cd_ans_int,
		ie_disponibilidade_serv,
		ie_urgencia_emergencia
	into STRICT	nr_seq_interc_movto_w,
		nr_seq_lote_w,
		cd_cgc_cpf_w,
		ds_razao_social_w,
		ie_tipo_w,
		cd_municipio_ibge_w,
		ie_contratacao_w,
		dt_contratacao_w,
		cd_cnes_w,
		dt_vinculo_w,
		cd_classificacao_w,
		cd_ans_int_w,
		ie_disponibilidade_serv_w,
		ie_urgencia_emergencia_w
	from	pls_prestador_interc_movto
	where	nr_sequencia = nr_seq_interc_movto_w;

	begin
	/* Se for CPF deverá conter 11 números, caso seja CPNJ deverá conter 14 */

	if (length((cd_cgc_cpf_w)::numeric ) <= 11) then
		SELECT * FROM pls_gerar_prest_intercambio(	(cd_cgc_cpf_w)::numeric , null, ds_razao_social_w, cd_cnes_w, cd_municipio_ibge_w, nm_usuario_p, null, null, nr_seq_prest_inter_w, nr_seq_prestador_w) INTO STRICT nr_seq_prest_inter_w, nr_seq_prestador_w;
	else
		SELECT * FROM pls_gerar_prest_intercambio(	null, cd_cgc_cpf_w, ds_razao_social_w, cd_cnes_w, cd_municipio_ibge_w, nm_usuario_p, null, null, nr_seq_prest_inter_w, nr_seq_prestador_w) INTO STRICT nr_seq_prest_inter_w, nr_seq_prestador_w;

	ds_retorno_p := 'S';
	end if;
	exception
	when others then
		ds_retorno_p := 'N';
		ds_erro_w := substr(SQLERRM,0,4000);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(330138, 'ERRO=' || ds_erro_w, -20012);
	end;

	if (nr_seq_prest_inter_w IS NOT NULL AND nr_seq_prest_inter_w::text <> '') then
		update	pls_prestador_intercambio
		set	ie_relacao_operadora	= coalesce(ie_relacao_operadora,CASE WHEN ie_tipo_w='2000' THEN 'C' WHEN ie_tipo_w='1000' THEN 'P'  ELSE null END ),
			ie_tipo_contratualizacao= coalesce(ie_tipo_contratualizacao,ie_contratacao_w),
			dt_contratualizacao	= coalesce(dt_contratualizacao,dt_contratacao_w),
			dt_inicio_servico	= coalesce(dt_inicio_servico,dt_vinculo_w),
			cd_classificacao	= coalesce(cd_classificacao,cd_classificacao_w),
			cd_ans_int		= coalesce(cd_ans_int,cd_ans_int_w),
			ie_disponibilidade_serv	= coalesce(ie_disponibilidade_serv,ie_disponibilidade_serv_w),
			ie_urgencia_emergencia	= coalesce(ie_urgencia_emergencia,ie_urgencia_emergencia_w)
		where	nr_sequencia		= nr_seq_prest_inter_w;
	end if;
	end;
end loop;
close C01;

/* Informar a data de geração dos prestadores.*/

update 	pls_lote_prestador_interc
set	dt_geracao_prest = clock_timestamp()
where	nr_sequencia = nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_dados_prest_inter ( nr_seq_lote_p text, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

