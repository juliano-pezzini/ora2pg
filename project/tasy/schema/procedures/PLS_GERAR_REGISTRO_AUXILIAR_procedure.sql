-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_registro_auxiliar ( nr_seq_reg_auxiliar_p bigint, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_tipo_registro_w		ctb_livro_auxiliar.ie_tipo_reg_auxiliar_ans%type;
ie_status_w			varchar(1);
dt_geracao_w			timestamp;
dt_liberacao_w			timestamp := null;


BEGIN

CALL wheb_usuario_pck.set_ie_executar_trigger('N');

select	max(ie_tipo_reg_auxiliar_ans),
	max(dt_geracao)
into STRICT	ie_tipo_registro_w,
	dt_geracao_w
from	ctb_livro_auxiliar
where	nr_sequencia	= nr_seq_reg_auxiliar_p;

if (ie_opcao_p = 'G') then
	if (ie_tipo_registro_w = '8000') then
		CALL pls_gerar_event_liq(nr_seq_reg_auxiliar_p, nm_usuario_p, cd_estabelecimento_p);
	elsif (ie_tipo_registro_w = '8003') then
		CALL pls_gerar_event_glosa(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p, 'H');
	elsif (ie_tipo_registro_w = '8005') then
		CALL pls_gerar_event_copart(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p);
	elsif (ie_tipo_registro_w = '8006') then
		CALL pls_gerar_debitos_nao_relac(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p, 'H');
	elsif (ie_tipo_registro_w = '8008') then
		CALL pls_gerar_contrap_emitida(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p);
	elsif (ie_tipo_registro_w = '8010') then
		CALL pls_gerar_contrap_receber(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p);
	elsif (ie_tipo_registro_w = '8011') then
		CALL pls_gerar_valores_faturar(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p);
	elsif (ie_tipo_registro_w = '8013') then
		CALL pls_gerar_event_avisados(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p);
	elsif (ie_tipo_registro_w = '8014') then
		CALL pls_gerar_contrap_recebidas(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p, 'H');
	elsif (ie_tipo_registro_w = '8024') then
		CALL pls_gerar_contr_gerencial(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p, 'H');
	elsif (ie_tipo_registro_w = '8025') then
		CALL pls_gerar_ress_sus(nr_seq_reg_auxiliar_p,nm_usuario_p,cd_estabelecimento_p, 'H');
	elsif (ie_tipo_registro_w = '8029') then
		CALL pls_gerar_event_pos_estab(nr_seq_reg_auxiliar_p, nm_usuario_p, cd_estabelecimento_p, 'H');
	end if;

	ie_status_w	:= '3';
	dt_geracao_w	:= clock_timestamp();
elsif (ie_opcao_p = 'D') then
	if (ie_tipo_registro_w = '8000') then
		delete	FROM pls_aux_event_liq
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8003') then
		delete	FROM pls_aux_event_glosa
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8005') then
		delete	FROM pls_aux_event_copart
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8006') then
		delete	FROM pls_aux_debitos_nao_relac
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8008') then
		delete	FROM pls_aux_contrap_emitida
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8010') then
		delete	FROM pls_aux_contrap_receber
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8011') then
		delete	FROM pls_aux_valores_faturar
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8013') then
		delete	FROM pls_aux_event_avisados
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8014') then
		delete	FROM pls_aux_contrap_recebidas
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8024') then
		delete	FROM pls_aux_contr_gerencial
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8025') then
		delete	FROM pls_aux_ress_sus
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	elsif (ie_tipo_registro_w = '8029') then
		delete	FROM pls_aux_event_pos_estab
		where	nr_seq_reg_auxiliar	= nr_seq_reg_auxiliar_p;
	end if;

	ie_status_w	:= '1';
	dt_geracao_w	:= null;
elsif (ie_opcao_p = 'L') then
	ie_status_w	:= '4';
	dt_liberacao_w	:= clock_timestamp();
elsif (ie_opcao_p = 'DL') then
	ie_status_w	:= '3';
end if;

update 	ctb_livro_auxiliar	a
set	a.ie_status	= ie_status_w,
	dt_geracao	= dt_geracao_w,
	dt_liberacao	= dt_liberacao_w,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_reg_auxiliar_p;

CALL wheb_usuario_pck.set_ie_executar_trigger('S');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_registro_auxiliar ( nr_seq_reg_auxiliar_p bigint, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

