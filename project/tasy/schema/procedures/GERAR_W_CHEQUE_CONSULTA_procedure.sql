-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_cheque_consulta (dt_referencia_p timestamp, cd_estabelecimento_p bigint, dt_venc_inicial_p timestamp, ie_quebra_p text, ie_tipo_relatorio_p text, ds_lista_status_p text, cd_pessoa_fisica_p text, cd_cgc_p text, cd_pessoa_fisica_atend_p text, ie_origem_cheque_p text, ie_considerar_cobranca_p text, cd_tipo_portador_p bigint, cd_portador_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
ie_quebra_p
	0 - Paciente
	1 - Emitente
	2 - Status

ie_tipo_relatorio_p
	0 - A vista
	1 - Pré-datados
	2 - Ambos

*/
ds_lista_status_w		varchar(2000);
ie_status_w			bigint;
nr_seq_cheque_w			bigint;
vl_cheque_w			double precision;

dt_vencimento_w			timestamp;
dt_vencimento_atual_w		timestamp;
dt_emissao_titulo_w		timestamp;
dt_contabil_w			timestamp;
dt_registro_w			timestamp;
cd_banco_w			bigint;
ds_banco_w			varchar(255);
cd_agencia_bancaria_w		varchar(255);
nr_conta_w			varchar(255);
nr_cheque_w			varchar(255);
cd_pessoa_fisica_w		varchar(255);
cd_cgc_w			varchar(255);
ds_emitente_w			varchar(255);
nm_paciente_w			varchar(255);
ds_quebra_w			varchar(255);
cd_pessoa_fisica_atend_w	varchar(255);
ie_tipo_cheque_w		varchar(255);
ie_emite_portador_w		varchar(255) := 'N';
ds_tipo_portador_w		varchar(255);
ds_portador_w			varchar(255);

nr_seq_caixa_rec_w		bigint;
nr_titulo_w			bigint;
nr_titulo_cheque_w		bigint;
dt_deposito_w			timestamp;
dt_devolucao_pac_w		timestamp;
dt_devolucao_banco_w		timestamp;
dt_reapresentacao_w		timestamp;
dt_seg_devolucao_w		timestamp;
dt_seg_reapresentacao_w		timestamp;
dt_terc_devolucao_w		timestamp;

nr_atendimento_w		bigint;
dt_emissao_w			timestamp;
/* Projeto Multimoeda - Variáveis */

vl_cheque_estrang_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_w			integer;

c01 CURSOR FOR
SELECT	(CASE WHEN ie_considerar_cobranca_p='S' THEN 	obter_status_cheque_contabil(a.nr_seq_cheque, dt_referencia_p)  ELSE obter_status_cheque_scob(a.nr_seq_cheque, dt_referencia_p) END )::numeric ,
	a.nr_seq_cheque,
	a.vl_cheque,
	a.nr_seq_caixa_rec,
	a.nr_titulo,
	a.cd_banco,
	a.cd_agencia_bancaria,
	a.nr_conta,
	a.nr_cheque,
	trunc(a.dt_contabil, 'dd'),
	a.dt_vencimento,
	trunc(obter_dt_venc_cheque_cr(a.nr_seq_cheque, dt_referencia_p), 'dd'),
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 10) dt_deposito,
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 70) dt_devolucao_pac,
	obter_nome_pf_pj(a.cd_pessoa_fisica, a.cd_cgc),
	coalesce(a.dt_registro, b.dt_recebimento),
	a.cd_pessoa_fisica,
	a.cd_cgc,
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 20) dt_devolucao_banco,
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 30) dt_reapresentacao,
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 40) dt_seg_devolucao,
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 50) dt_seg_reapresentacao,
	obter_dt_cheque_cr(a.nr_seq_cheque, dt_referencia_p, 60) dt_terc_devolucao,
	Obter_Dados_Cheque_CR(a.nr_seq_cheque, 'CP') cd_pessoa_fisica_atend,
	obter_portador_cheque_data(a.nr_seq_cheque, dt_referencia_p, 'DT') ds_tipo_portador,
	obter_portador_cheque_data(a.nr_seq_cheque, dt_referencia_p, 'DP') ds_portador,
	a.vl_cheque_estrang,
	a.vl_cotacao,
	a.cd_moeda
FROM cheque_cr a
LEFT OUTER JOIN caixa_receb b ON (a.nr_seq_caixa_rec = b.nr_sequencia)
WHERE a.cd_estabelecimento						= cd_estabelecimento_p  and trunc(a.dt_contabil, 'dd') 					<= trunc(dt_referencia_p, 'dd') and trunc(coalesce(a.dt_vencimento_atual, a.dt_vencimento), 'dd')	>= trunc(dt_venc_inicial_p, 'dd') and (((OBTER_SE_CHEQUE_CR_AVISTA(a.nr_seq_cheque)			= 'S') and (ie_tipo_relatorio_p = 0)) or
	 ((OBTER_SE_CHEQUE_CR_AVISTA(a.nr_seq_cheque)			= 'N') and (ie_tipo_relatorio_p = 1)) or (ie_tipo_relatorio_p = 2)) and coalesce(a.cd_pessoa_fisica, 'X')					= coalesce(cd_pessoa_fisica_p, coalesce(a.cd_pessoa_fisica, 'X')) and coalesce(a.cd_cgc, 'X')						= coalesce(cd_cgc_p, coalesce(a.cd_cgc, 'X')) and (coalesce(ds_lista_status_w, '-1')		like '% ' || CASE WHEN ie_considerar_cobranca_p='S' THEN 								obter_status_cheque_contabil(a.nr_seq_cheque, dt_referencia_p)  ELSE obter_status_cheque_scob(a.nr_seq_cheque, dt_referencia_p) END  || ' %') and ((obter_portador_cheque_data(a.nr_seq_cheque, dt_referencia_p, 'CT')	= cd_tipo_portador_p) or (coalesce(cd_tipo_portador_p::text, '') = '')) and ((obter_portador_cheque_data(a.nr_seq_cheque, dt_referencia_p, 'CP')	= cd_portador_p) or (coalesce(cd_portador_p::text, '') = '')) and (a.ie_origem_cheque							= ie_origem_cheque_p or coalesce(ie_origem_cheque_p::text, '') = '') and ((Obter_Dados_Cheque_CR(a.nr_seq_cheque, 'CP') = cd_pessoa_fisica_atend_p) or (coalesce(cd_pessoa_fisica_atend_p::text, '') = ''));


BEGIN

delete 	from W_CHEQUE_CONSULTA
where	nm_usuario	= nm_usuario_p
or	dt_atualizacao	< clock_timestamp() - interval '1 days';

ds_lista_status_w			:= replace(' ' || replace(replace(replace(ds_lista_status_p, ',', ' '), '(', ' '), ')', ' ') || ' ', '  ',' ');
if (coalesce(trim(both ds_lista_status_w)::text, '') = '') then
	ds_lista_status_w		:= null;
end if;

commit;

open c01;
loop
fetch c01 into
	ie_status_w,
	nr_seq_cheque_w,
	vl_cheque_w,
	nr_seq_caixa_rec_w,
	nr_titulo_cheque_w,
	cd_banco_w,
	cd_agencia_bancaria_w,
	nr_conta_w,
	nr_cheque_w,
	dt_contabil_w,
	dt_vencimento_w,
	dt_vencimento_atual_w,
	dt_deposito_w,
	dt_devolucao_pac_w,
	ds_emitente_w,
	dt_registro_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	dt_devolucao_banco_w,
	dt_reapresentacao_w,
	dt_seg_devolucao_w,
	dt_seg_reapresentacao_w,
	dt_terc_devolucao_w,
	cd_pessoa_fisica_atend_w,
	ds_tipo_portador_w,
	ds_portador_w,
	vl_cheque_estrang_w,
	vl_cotacao_w,
	cd_moeda_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	max(nr_titulo)
	into STRICT	nr_titulo_w
	from	titulo_receber_liq
	where	nr_seq_caixa_rec	= nr_seq_caixa_rec_w;

	nr_titulo_w			:= coalesce(nr_titulo_cheque_w, nr_titulo_w);

	select	max(nr_atendimento),
		max(dt_emissao)
	into STRICT	nr_atendimento_w,
		dt_emissao_titulo_w
	from	titulo_receber
	where	nr_titulo		= nr_titulo_w;

	nm_paciente_w			:= obter_pessoa_atendimento(nr_atendimento_w, 'N');

	if (dt_contabil_w <> dt_vencimento_atual_w) then
		ie_tipo_cheque_w			:= 'P';  /* cheque pré-datado */
	else
		ie_tipo_cheque_w			:= 'V';  /* cheque a vista */
	end if;

	if (ie_quebra_p = 0) then
		ds_quebra_w	:= coalesce(nm_paciente_w, OBTER_DESC_EXPRESSAO(612231));
	elsif (ie_quebra_p = 1) then
		ds_quebra_w	:= ds_emitente_w;
	elsif (ie_quebra_p = 2) then
		if (ie_status_w = 1) then
			if (dt_contabil_w <> dt_vencimento_atual_w) then
				ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727960);
			else
				ds_quebra_w	:= OBTER_DESC_EXPRESSAO(728410);
			end if;
		elsif (ie_status_w = 2) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727974);
		elsif (ie_status_w = 3) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727978);
		elsif (ie_status_w = 4) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727980);
		elsif (ie_status_w = 5) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727982);
		elsif (ie_status_w = 6) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727986);
		elsif (ie_status_w = 7) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727990);
		elsif (ie_status_w = 8) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727992);
		elsif (ie_status_w = 9) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(727996);
		elsif (ie_status_w = 10) then
			ds_quebra_w	:= OBTER_DESC_EXPRESSAO(728002);
		end if;
	end if;

	/* Projeto Multimoeda - Verifica se o cheque é moeda estrangeira, grava os valores somente quando moeda estrangeira.*/

	if (coalesce(vl_cheque_estrang_w,0) = 0 and coalesce(vl_cotacao_w,0) = 0) then
		vl_cheque_estrang_w := null;
		vl_cotacao_w := null;
	end if;

	insert into W_CHEQUE_CONSULTA(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_cheque,
		vl_cheque,
		dt_vencimento,
		dt_vencimento_atual,
		dt_contabil,
		cd_banco,
		ds_banco,
		cd_agencia,
		nr_conta,
		nr_cheque,
		cd_pessoa_fisica,
		cd_cgc,
		ds_emitente,
		nm_paciente,
		nr_titulo,
		dt_emissao_titulo,
		dt_deposito,
		dt_devolucao_pac,
		dt_registro,
		ds_quebra,
		ie_status,
		dt_devolucao_banco,
		dt_reapresentacao,
		dt_seg_devolucao,
		dt_seg_reapresentacao,
		dt_terc_devolucao,
		ie_tipo_cheque,
		cd_pessoa_fisica_atend,
		ds_tipo_portador,
		ds_portador,
		vl_cheque_estrang,
		vl_cotacao,
		cd_moeda)
	values (nextval('w_cheque_consulta_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_cheque_w,
		vl_cheque_w,
		dt_vencimento_w,
		dt_vencimento_atual_w,
		dt_contabil_w,
		cd_banco_w,
		ds_banco_w,
		cd_agencia_bancaria_w,
		nr_conta_w,
		nr_cheque_w,
		cd_pessoa_fisica_w,
		cd_cgc_w,
		ds_emitente_w,
		nm_paciente_w,
		nr_titulo_w,
		dt_emissao_titulo_w,
		dt_deposito_w,
		dt_devolucao_pac_w,
		dt_registro_w,
		ds_quebra_w,
		ie_status_w,
		dt_devolucao_banco_w,
		dt_reapresentacao_w,
		dt_seg_devolucao_w,
		dt_seg_reapresentacao_w,
		dt_terc_devolucao_w,
		ie_tipo_cheque_w,
		cd_pessoa_fisica_atend_w,
		ds_tipo_portador_w,
		ds_portador_w,
		vl_cheque_estrang_w,
		vl_cotacao_w,
		cd_moeda_w);

end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_cheque_consulta (dt_referencia_p timestamp, cd_estabelecimento_p bigint, dt_venc_inicial_p timestamp, ie_quebra_p text, ie_tipo_relatorio_p text, ds_lista_status_p text, cd_pessoa_fisica_p text, cd_cgc_p text, cd_pessoa_fisica_atend_p text, ie_origem_cheque_p text, ie_considerar_cobranca_p text, cd_tipo_portador_p bigint, cd_portador_p bigint, nm_usuario_p text) FROM PUBLIC;

