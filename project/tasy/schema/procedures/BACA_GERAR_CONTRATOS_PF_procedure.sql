-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_gerar_contratos_pf ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_erro_w				varchar(4000);
cd_pessoa_fisica_w			varchar(10);
ie_tipo_erro_w				varchar(1);
nr_seq_contrato_w			bigint;
nr_seq_pagador_w			bigint;
nr_seq_plano_w				bigint;
nr_contrato_w				bigint;
nr_seq_lote_w				bigint;
nr_seq_tabela_w				bigint;
qt_registro_w				bigint	:= 0;

C01 CURSOR FOR 
	SELECT	cd_pessoa_fisica 
	from	pessoa_fisica 
	where	trunc(dt_atualizacao,'dd') between to_date('10/07/2007') and to_date('11/07/2007');
	
C02 CURSOR FOR 
	SELECT	nr_seq_contrato, 
		nr_seq_pagador 
	from	pls_segurado 
	where	trunc(dt_atualizacao,'dd') between to_date('02/06/2011') and to_date('03/06/2011');

BEGIN
 
open C01;
loop 
fetch C01 into	 
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	nextval('pls_contrato_seq'), 
		nextval('nr_contrato_seq') 
	into STRICT	nr_seq_contrato_w, 
		nr_contrato_w 
	;
	 
	insert into pls_contrato(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			ie_situacao, 
			dt_contrato, 
			ie_renovacao_automatica, 
			ie_permite_prod_dif, 
			ie_reajuste, 
			cd_estabelecimento, 
			ie_geracao_valores, 
			ie_tipo_operacao, 
			ie_controle_carteira, 
			nr_contrato, 
			cd_pf_estipulante, 
			nr_seq_emissor) 
		values (nr_seq_contrato_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			'1', 
			clock_timestamp(), 
			'N', 
			'N', 
			'C', 
			cd_estabelecimento_p, 
			'B', 
			'B', 
			'A', 
			nr_contrato_w, 
			cd_pessoa_fisica_w, 
			7);
	 
	select	nextval('pls_contrato_plano_seq') 
	into STRICT	nr_seq_plano_w 
	;
	 
	insert into pls_contrato_plano(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_contrato, 
			nr_seq_plano, 
			nr_seq_tabela_origem, 
			ie_situacao, 
			ie_tipo_operacao) 
		values (nr_seq_plano_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_contrato_w, 
			98, 
			14875, 
			'A', 
			'B');
			 
	CALL pls_gerar_tabela_contrato(	nr_seq_contrato_w, 
					98, 
					14875, 
					cd_estabelecimento_p, 
					nm_usuario_p);
					 
	select	nr_seq_tabela 
	into STRICT	nr_seq_tabela_w 
	from	pls_contrato_plano 
	where	nr_sequencia	= nr_seq_plano_w;
	 
	select	nextval('pls_contrato_pagador_seq') 
	into STRICT	nr_seq_pagador_w 
	;
	 
	insert into pls_contrato_pagador(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			ie_tipo_pagador, 
			ie_endereco_boleto, 
			ie_calc_primeira_mens, 
			cd_pessoa_fisica, 
			nr_seq_contrato) 
		values (nr_seq_pagador_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			'P', 
			'PFR', 
			'I', 
			cd_pessoa_fisica_w, 
			nr_seq_contrato_w);
			 
	insert into pls_contrato_pagador_fin(nr_sequencia, 
			dt_dia_vencimento, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_pagador, 
			nr_seq_forma_cobranca, 
			dt_inicio_vigencia, 
			cd_condicao_pagamento, 
			ie_mes_vencimento, 
			ie_geracao_nota_titulo, 
			cd_tipo_portador, 
			cd_portador, 
			nr_seq_conta_banco) 
		values (nextval('pls_contrato_pagador_fin_seq'), 
			10, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_pagador_w, 
			1, 
			trunc(clock_timestamp(),'month'), 
			2, 
			'A', 
			'T', 
			1, 
			1, 
			1331);
			 
	insert into pls_segurado(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			cd_pessoa_fisica, 
			ie_situacao_atend, 
			cd_estabelecimento, 
			nr_seq_pagador, 
			nr_seq_contrato, 
			dt_contratacao, 
			nr_seq_vendedor_canal, 
			nr_seq_plano, 
			nr_seq_tabela) 
		values (nextval('pls_segurado_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_pessoa_fisica_w, 
			'A', 
			cd_estabelecimento_p, 
			nr_seq_pagador_w, 
			nr_seq_contrato_w, 
			clock_timestamp(), 
			13, 
			98, 
			nr_seq_tabela_w);
	 
	SELECT * FROM pls_aprovar_contrato(	nr_seq_contrato_w, nm_usuario_p, cd_estabelecimento_p, ds_erro_w, 'S', 'N', 'S', 'N', ie_tipo_erro_w) INTO STRICT ds_erro_w, ie_tipo_erro_w;
				 
	if (ds_erro_w <> '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort( 267146, null);
	end if;
	 
	qt_registro_w	:= qt_registro_w + 1;
	 
	if (qt_registro_w = 500) then 
		commit;
		qt_registro_w	:= 0;
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_gerar_contratos_pf ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
