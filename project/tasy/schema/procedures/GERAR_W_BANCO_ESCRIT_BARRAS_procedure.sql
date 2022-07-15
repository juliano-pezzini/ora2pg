-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_banco_escrit_barras ( nm_usuario_p text, IE_VINCULADO_P text, IE_DATA_P bigint, DT_INICIAL_P timestamp, DT_FINAL_P timestamp, CD_CGC_P text, VL_MINIMO_P bigint, VL_MAXIMO_P bigint) AS $body$
DECLARE


nr_sequencia_w		banco_escrit_barras.nr_sequencia%type;
dt_lote_w			banco_escrit_lote.dt_lote%type;
dt_emissao_w		banco_escrit_barras.dt_emissao%type;
nr_titulo_w		banco_escrit_barras.nr_titulo%type;
cd_cgc_w		varchar(255);
cd_barras_w		banco_escrit_barras.cd_barras%type;
nm_pessoa_w		varchar(255);
ds_banco_w		banco.ds_banco%type;
nr_conta_w		varchar(255);
ie_digito_conta_w		varchar(255);
cd_agencia_w		varchar(255);
ie_digito_agencia_w	varchar(255);
vl_bloqueto_w		double precision;
dt_vencimento_w		timestamp;
ds_sacador_avalista_w	banco_escrit_barras.ds_sacador_avalista%type;
nr_documento_w		banco_escrit_barras.nr_documento%type;
nr_nosso_numero_w	banco_escrit_barras.nr_nosso_numero%type;
cd_banco_lote_w		banco_estabelecimento.cd_banco%type;



C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.dt_lote,
		a.dt_emissao,
		a.nr_titulo,
		coalesce(a.cd_cgc,a.cd_pessoa_externo) cd_cgc,
		a.cd_barras,
		substr(coalesce(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),wheb_mensagem_pck.get_texto(302527,null) || ' - ' || a.nm_pessoa_externo),1,255) nm_pessoa, -- Pessoa não cadastrada
		substr(obter_nome_banco(somente_numero(obter_dados_cod_barras(a.cd_barras,'B'))),1,254) ds_banco,
		substr(obter_dados_cod_barras(a.cd_barras,'C'),1,254) nr_conta,
		substr(obter_dados_cod_barras(a.cd_barras,'DC'),1,254) ie_digito_conta,
		substr(obter_dados_cod_barras(a.cd_barras,'A'),1,254) cd_agencia,
		substr(obter_dados_cod_barras(a.cd_barras,'DA'),1,254) ie_digito_agencia,
		(obter_dados_cod_barras(a.cd_barras,'V'))::numeric  vl_bloqueto,
		to_date(obter_dados_cod_barras(a.cd_barras,'DT'),'dd/mm/yyyy') dt_vencimento,
		a.ds_sacador_avalista,
		a.nr_documento,
		a.nr_nosso_numero,
		coalesce((	SELECT	max(x.cd_banco)
			from	banco_estabelecimento x
			where	x.nr_sequencia	= b.nr_seq_conta_banco),c.cd_banco) cd_banco_lote
	FROM banco_escrit_barras a
LEFT OUTER JOIN banco_escritural c ON (a.nr_seq_banco_escrit = c.nr_sequencia)
LEFT OUTER JOIN banco_escrit_lote b ON (a.nr_seq_lote = b.nr_sequencia)
WHERE ((coalesce(obter_param_usuario_logado(857,68),'N') = 'N' and (coalesce(b.cd_estabelecimento,c.cd_estabelecimento) = obter_estabelecimento_ativo or obter_se_estab_financeiro(obter_estabelecimento_ativo, coalesce(b.cd_estabelecimento,c.cd_estabelecimento)) = 'S')) or coalesce(obter_param_usuario_logado(857,68),'N') = 'S') and (0 = coalesce(ie_vinculado_p,0) or (2 = ie_vinculado_p and coalesce(a.nr_titulo::text, '') = '') or (1 = ie_vinculado_p and (a.nr_titulo IS NOT NULL AND a.nr_titulo::text <> ''))) and (0 = coalesce(IE_DATA_p,0) or (1 = IE_DATA_p and b.dt_lote between trunc(DT_INICIAL_P,'dd') and fim_dia(DT_FINAL_P)) or (2 = IE_DATA_p and a.dt_emissao between trunc(DT_INICIAL_P,'dd') and fim_dia(DT_FINAL_P)) or (3 = IE_DATA_p and to_date(obter_dados_cod_barras(a.cd_barras,'DT'),'dd/mm/yyyy') between trunc(DT_INICIAL_P,'dd') and fim_dia(DT_FINAL_P))) and (a.cd_cgc = CD_CGC_P or coalesce(CD_CGC_P,'0') = '0') and ((obter_dados_cod_barras(a.cd_barras,'V'))::numeric  between coalesce(VL_MINIMO_P,(obter_dados_cod_barras(a.cd_barras,'V'))::numeric ) and coalesce(VL_MAXIMO_P,(obter_dados_cod_barras(a.cd_barras,'V'))::numeric )) order by	a.nr_sequencia;
					

BEGIN

delete from w_banco_escrit_barras
where	nm_usuario = nm_usuario_p;

open C01;
loop
fetch C01 into	
	nr_sequencia_w,
	dt_lote_w,
	dt_emissao_w,
	nr_titulo_w,
	cd_cgc_w,
	cd_barras_w,
	nm_pessoa_w,
	ds_banco_w,
	nr_conta_w,
	ie_digito_conta_w,
	cd_agencia_w,
	ie_digito_agencia_w,
	vl_bloqueto_w,
	dt_vencimento_w,
	ds_sacador_avalista_w,
	nr_documento_w,
	nr_nosso_numero_w,
	cd_banco_lote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	insert into w_banco_escrit_barras(		NR_SEQUENCIA,
						NR_SEQ_BARRAS,
						NM_USUARIO,
						DT_LOTE, 
						DT_EMISSAO, 
						NR_TITULO, 
						CD_CGC, 
						CD_BARRAS, 
						NM_PESSOA, 
						DS_BANCO, 
						NR_CONTA, 
						IE_DIGITO_CONTA, 
						CD_AGENCIA_BANCARIA, 
						IE_DIGITO_AGENCIA, 
						VL_BLOQUETO, 
						DT_VENCIMENTO, 
						DS_SACADOR_AVALISTA, 
						NR_DOCUMENTO, 
						NR_NOSSO_NUMERO, 
						CD_BANCO)
				values (		nextval('w_banco_escrit_barras_seq'),
						nr_sequencia_w,
						nm_usuario_p,
						dt_lote_w,
						dt_emissao_w,
						nr_titulo_w,
						cd_cgc_w,
						cd_barras_w,
						nm_pessoa_w,
						ds_banco_w,
						nr_conta_w,
						ie_digito_conta_w,
						cd_agencia_w,
						ie_digito_agencia_w,
						vl_bloqueto_w,
						dt_vencimento_w,
						ds_sacador_avalista_w,
						nr_documento_w,
						nr_nosso_numero_w,
						cd_banco_lote_w);
	
	
	
	
	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_banco_escrit_barras ( nm_usuario_p text, IE_VINCULADO_P text, IE_DATA_P bigint, DT_INICIAL_P timestamp, DT_FINAL_P timestamp, CD_CGC_P text, VL_MINIMO_P bigint, VL_MAXIMO_P bigint) FROM PUBLIC;

