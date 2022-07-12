-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_mensagem_notificacao (nr_seq_controle_p ctb_sped_controle.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);
ds_informacao_w	ctb_sped_controle.ds_informacao%type;
nr_seq_regra_w	ctb_sped_controle.nr_seq_regra_sped%type;
ie_forma_gerar_w	varchar(1);
ds_local_rede_w	evento_tasy_utl_file.ds_local_rede%type;
nm_usuario_w	ctb_sped_controle.nm_usuario%type;

BEGIN

select	ds_local_rede
into STRICT		ds_local_rede_w
from 	evento_tasy_utl_file
where	cd_evento = 25
and 		cd_funcao = 923
and 		ie_tipo = 'G'  LIMIT 1;

select	coalesce(ds_informacao, 'X'),
			nr_seq_regra_sped,
			nm_usuario
into STRICT		ds_informacao_w,
			nr_seq_regra_w,
			nm_usuario_w
from		ctb_sped_controle a
where	nr_sequencia = nr_seq_controle_p;

ie_forma_gerar_w	:=	coalesce(obter_parametro_funcao_padrao(923, 88, coalesce(wheb_usuario_pck.get_nm_usuario, nm_usuario_w)),'S');

if (ds_informacao_w = 'X') then
	/*Arquivo da regra/controle [#@NR_SEQ_REGRA#@/#@NR_SEQ_CONTROLE#@] gerado com sucesso.*/

	ds_retorno_w :=  wheb_mensagem_pck.get_texto(1157343, 'NR_SEQ_REGRA='||nr_seq_regra_w||';NR_SEQ_CONTROLE='||nr_seq_controle_p);
	if (ie_forma_gerar_w = 'B') then
		/*Arquivo disponivel no diretorio: #@DS_DIRETORIO#@*/

		ds_retorno_w	:=	ds_retorno_w || chr(10) || wheb_mensagem_pck.get_texto(1157835, 'DS_DIRETORIO='||ds_local_rede_w);
	else
		/*Clique em "Visualizar" para abrir a funcao "Contabilidade" e gerar o arquivo pelo menu contextual "Gerar somente arquivo".*/

		ds_retorno_w	:=	ds_retorno_w || chr(10) || wheb_mensagem_pck.get_texto(1157836);
	end if;
else
	/*Erro ao gerar arquivo da regra/controle [#@NR_SEQ_REGRA#@/#@NR_SEQ_CONTROLE#@]: #@DS_ERRO#@*/

	ds_retorno_w	:=	 wheb_mensagem_pck.get_texto(1157837,
		'NR_SEQ_REGRA='||nr_seq_regra_w||';'||
		'NR_SEQ_CONTROLE='||nr_seq_controle_p||';'||
		'DS_ERRO='||ds_informacao_w);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_mensagem_notificacao (nr_seq_controle_p ctb_sped_controle.nr_sequencia%type) FROM PUBLIC;

