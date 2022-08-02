-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_guia_web ( nr_seq_guia_p bigint, ie_glosa_biometria_p text, ie_calcula_franquia_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Criada esta rotina para manter todas as rotinas utilizadas no portal no momento de consistir a guia
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ x ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 				
			
ie_lanc_auto_w	varchar(5);
ie_tipo_processo_w pls_guia_plano.ie_tipo_processo%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
			'P' ie_tipo
	from	pls_guia_plano_proc
	where	nr_seq_guia = nr_seq_guia_p
	
union
	
	SELECT	nr_sequencia,
			'M' ie_tipo
	from	pls_guia_plano_mat
	where	nr_seq_guia = nr_seq_guia_p;
			
BEGIN

begin
	select	ie_tipo_processo
	into STRICT	ie_tipo_processo_w
	from	pls_guia_plano
	where	nr_sequencia 	= nr_seq_guia_p;
exception
when no_data_found then
	ie_tipo_processo_w := null;
when too_many_rows then
	ie_tipo_processo_w := null;
end;

/* Rotina utilizada para consistir a biometria da Autorizacao 
Parametro 10 - Funcao OPSW - Autorizacoes
*/
if (coalesce(ie_glosa_biometria_p,'N') = 'S') then
	CALL pls_consistir_biometria(nr_seq_guia_p,cd_estabelecimento_p, nm_usuario_p);
end if;

/* Regra de lancamento automatico para a guia */

ie_lanc_auto_w := pls_gerar_proced_autor_regra(nr_seq_guia_p, null, '8', nm_usuario_p, ie_lanc_auto_w);

/* Rotina utilizada para abrir pacote na autorizacao do portal */

CALL pls_gerar_pacote_valor_web(nr_seq_guia_p, nm_usuario_p, cd_estabelecimento_p);

/* Regra de lancamento automatico para a guia, com base nos itens da mesma */
					
for cr01 in C01 loop
	begin
		if (cr01.ie_tipo = 'P') then
			CALL pls_lanc_auto_autorizacao(nr_seq_guia_p, cr01.nr_sequencia, null, nm_usuario_p, cd_estabelecimento_p);
			
			if (ie_tipo_processo_w = 'I') then
				CALL pls_gerar_de_para_aut_intercam(cr01.nr_sequencia, null, cd_estabelecimento_p, nm_usuario_p);
			end if;
		else
			CALL pls_lanc_auto_autorizacao(nr_seq_guia_p, null, cr01.nr_sequencia, nm_usuario_p, cd_estabelecimento_p);
			
			if (ie_tipo_processo_w = 'I') then
				CALL pls_gerar_de_para_aut_intercam(null, cr01.nr_sequencia, cd_estabelecimento_p, nm_usuario_p);
			end if;
			
		end if;
	end;
end loop;

/* Rotina utilizada para consistencia da autorizacao Portal e Tasy */

CALL pls_consistir_guia(nr_seq_guia_p,cd_estabelecimento_p, nm_usuario_p);

/* Rotina utilizada para gerar o calculo da franquia 
Parametro 20 - Funcao OPSW - Autorizacoes
 */
if (coalesce(ie_calcula_franquia_p,'N') = 'S') then
	CALL pls_gerar_franquia_guia(nr_seq_guia_p,cd_estabelecimento_p, nm_usuario_p);
end if;


/* Gerar justificativa automatica para as guias que ficaram em analise
Regra criada na funcao OPS - Cadastro de Regras / OPS - Atendimento / Regra justificativa automatica
*/
CALL pls_gerar_justific_automatica(null,nr_seq_guia_p,nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_guia_web ( nr_seq_guia_p bigint, ie_glosa_biometria_p text, ie_calcula_franquia_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

