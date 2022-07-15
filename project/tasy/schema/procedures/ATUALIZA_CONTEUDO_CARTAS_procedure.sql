-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_conteudo_cartas ( nr_atendimento_p bigint, nr_seq_carta_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_carta_conteudo_w		carta_conteudo.nr_sequencia%type;
nr_seq_carta_mae_w			carta_medica.nr_seq_carta_mae%type;
nr_seq_episodio_w			carta_medica.nr_seq_episodio%type;
ie_metodo_busca_info_w		carta_medica_modelo.ie_metodo_busca_info%type;
nr_seq_modelo_w				carta_medica.nr_seq_modelo%type;
ie_incluir_inf_adic_w		carta_medica_regra_item.ie_incluir_inf_adic%type;
ie_possui_info_adic_diag_w	varchar(1);
--ds_texto_w					clob;
const_diagnostico_w 		constant varchar(2) := 'DI';

C01 CURSOR FOR
	SELECT	nr_sequencia,
			ds_texto,
			ie_tipo_item,
			ie_incluir_aut,
			ie_incluso_carta,
			case
				when (nr_prescricao IS NOT NULL AND nr_prescricao::text <> '') then nr_prescricao 
				when (nr_seq_diag_doenca_inf IS NOT NULL AND nr_seq_diag_doenca_inf::text <> '') then nr_seq_diag_doenca_inf 
			end nr_seq_result_item,
			nr_seq_prescricao,
			ie_tipo_nota_clinica,
			coalesce(nr_seq_cirurgia,nr_seq_alergia,cd_evolucao,nr_seq_medic_uso,nr_seq_comorbidade,nr_seq_procedimento, nr_seq_proc_pac,nr_seq_laudo,nr_seq_kv_item,nr_seq_mat_cpoe,nr_seq_rec_cpoe,nr_seq_diag_doenca,NR_SEQ_PLANO_VERSAO_MEDIC) cd_chave
	from	carta_conteudo_relevante
	where	(
			(ie_metodo_busca_info_w = 'N' and nr_atendimento = nr_atendimento_p)
		or (ie_metodo_busca_info_w = 'S' and nr_seq_episodio = nr_seq_episodio_w));

BEGIN

select	max(coalesce(b.ie_metodo_busca_info,'N')) ie_metodo_busca_info,
		max(a.nr_seq_episodio),
		max(coalesce(a.nr_seq_carta_mae, a.nr_sequencia)),
		max(a.nr_seq_modelo)
into STRICT	ie_metodo_busca_info_w,
		nr_seq_episodio_w,
		nr_seq_carta_mae_w,
		nr_seq_modelo_w
from	carta_medica a,
		carta_medica_modelo b
where	a.nr_seq_modelo = b.nr_sequencia
and		a.nr_sequencia 	= nr_seq_carta_p;

for c01_w in C01 loop
		begin
		ie_incluir_inf_adic_w := 'N';
		if (c01_w.ie_tipo_item = const_diagnostico_w) then
			select	coalesce(max('S'),'N'),
					max(obter_se_inf_adic_diag_carta(nr_seq_modelo_w))
			into STRICT	ie_incluir_inf_adic_w,
					ie_possui_info_adic_diag_w
			from	carta_medica_regra a,
					carta_medica_regra_item b,
					carta_medica_modelo c
			where	a.nr_sequencia 	= b.nr_seq_regra
			and		a.nr_seq_modelo = c.nr_sequencia
			and   	c.nr_sequencia  = nr_seq_modelo_w
			and		coalesce(ie_incluir_inf_adic,'N') = 'S'
			and		exists (SELECT	1
							 from	diagnostico_doenca x
							 where	nr_seq_interno = c01_w.cd_chave
							 and (coalesce(b.ie_classificacao_doenca::text, '') = '' or coalesce(b.ie_classificacao_doenca, x.ie_classificacao_doenca) = x.ie_classificacao_doenca)
							 and (coalesce(b.ie_tipo_diagnostico::text, '') = '' or coalesce(b.ie_tipo_diagnostico, x.ie_tipo_diagnostico) 		= x.ie_tipo_diagnostico));
							
			if ((ie_incluir_inf_adic_w = 'N' and coalesce(c01_w.nr_seq_result_item::text, '') = '') or (ie_incluir_inf_adic_w = 'S')) then 			
				nr_seq_carta_conteudo_w := inserir_log_carta(	nr_seq_carta_p, c01_w.ie_tipo_item, c01_w.cd_chave, c01_w.ds_texto, nm_usuario_p, c01_w.nr_seq_result_item, c01_w.nr_seq_prescricao,  --nr_seq_result_item_p,
									c01_w.ie_incluir_aut, nr_seq_carta_conteudo_w, c01_w.ie_tipo_nota_clinica,  --ie_tipo_regra_p,
									c01_w.ie_incluso_carta, nr_seq_carta_mae_w, c01_w.nr_sequencia );
			end if;
		else
			nr_seq_carta_conteudo_w := inserir_log_carta(	nr_seq_carta_p, c01_w.ie_tipo_item, c01_w.cd_chave, c01_w.ds_texto, nm_usuario_p, c01_w.nr_seq_result_item, c01_w.nr_seq_prescricao,  --nr_seq_result_item_p,
								c01_w.ie_incluir_aut, nr_seq_carta_conteudo_w, c01_w.ie_tipo_nota_clinica,  --ie_tipo_regra_p,
								c01_w.ie_incluso_carta, nr_seq_carta_mae_w, c01_w.nr_sequencia );
		end if;
		end;
	end loop;


commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_conteudo_cartas ( nr_atendimento_p bigint, nr_seq_carta_p bigint, nm_usuario_p text) FROM PUBLIC;

