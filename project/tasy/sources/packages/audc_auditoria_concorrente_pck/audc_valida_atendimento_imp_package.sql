-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE audc_auditoria_concorrente_pck.audc_valida_atendimento_imp ( nr_seq_lote_atend_imp_p audc_lote_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finality: Validacao aplicada no arquivo com os atendimentos enviados pelo prestador
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ x ] Outros: WebService
 ------------------------------------------------------------------------------------------------------------------

Caution:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


qt_registro_w			integer;
ie_origem_lote_w		audc_lote_atendimento_imp.ie_origem_lote%type;

C01 CURSOR(  nr_seq_lote_atend_imp_pc	audc_lote_atendimento_imp.nr_sequencia%type ) FOR
	SELECT  a.nr_sequencia,
	        a.cd_guia_operadora,
	        a.cd_cartao_beneficiario,
          	a.nr_seq_prestador_solic,
         	b.cd_ans,
		a.cd_estabelecimento
	from    audc_atendimento_imp a,
          	audc_lote_atendimento_imp b
	where	a.nr_seq_lote_atend_imp = b.nr_sequencia
  	and    	a.nr_seq_lote_atend_imp = nr_seq_lote_atend_imp_pc;


BEGIN


select  max(b.ie_origem_lote)
into STRICT	ie_origem_lote_w
from    audc_lote_atendimento_imp b
where	b.nr_sequencia = nr_seq_lote_atend_imp_p;


if (nr_seq_lote_atend_imp_p IS NOT NULL AND nr_seq_lote_atend_imp_p::text <> '') then

	/*So aplica validacoes se a origem do arquivo foi via Webservice */


	if ( ie_origem_lote_w = 'W' ) then

		/*Rotina utilizada para atualizar dados referente aos atendimentos importados */


		CALL audc_auditoria_concorrente_pck.audc_atualizar_atend_imp( nr_seq_lote_atend_imp_p, nm_usuario_p);

		/*Rotina utilizada para atualizar dados referente aos procedimentos */


		CALL audc_auditoria_concorrente_pck.audc_atualizar_atend_proc_imp( nr_seq_lote_atend_imp_p, nm_usuario_p);

		/*Rotina utilizada para atualizar dados referente aos materiais */


		CALL audc_auditoria_concorrente_pck.audc_atualizar_atend_mat_imp( nr_seq_lote_atend_imp_p, nm_usuario_p);

		for c01_w in C01( nr_seq_lote_atend_imp_p ) loop

			qt_registro_w := 0;
			select  count(1)
			into STRICT	qt_registro_w
			from    pls_segurado_carteira
			where   cd_usuario_plano = c01_w.cd_cartao_beneficiario;


			if ( qt_registro_w = 0 ) then
				select  count(1)
				into STRICT	qt_registro_w
				from    pls_segurado_carteira
				where   nr_cartao_intercambio = c01_w.cd_cartao_beneficiario;

				if ( qt_registro_w = 0 ) then
					CALL audc_auditoria_concorrente_pck.audc_grava_mensagem( wsuite_util_pck.get_wsuite_expression_domain(9479, 'C001', c01_w.cd_estabelecimento) ||c01_w.cd_cartao_beneficiario,'C001', c01_w.nr_sequencia, nm_usuario_p);
				end if;
			end if;


			qt_registro_w := 0;
			select  count(1)
			into STRICT	qt_registro_w
			from    pls_prestador
			where   nr_sequencia = c01_w.nr_seq_prestador_solic;


			if ( qt_registro_w = 0 ) then
				CALL audc_auditoria_concorrente_pck.audc_grava_mensagem( wsuite_util_pck.get_wsuite_expression_domain(9479, 'C002', c01_w.cd_estabelecimento),'C002', c01_w.nr_sequencia, nm_usuario_p);
			end if;


			qt_registro_w := 0;
			select  count(1)
			into STRICT	qt_registro_w
			from    pls_guia_plano
			where   cd_guia = c01_w.cd_guia_operadora
			and     nr_seq_prestador = c01_w.nr_seq_prestador_solic;

			if ( qt_registro_w = 0 ) then
				CALL audc_auditoria_concorrente_pck.audc_grava_mensagem( wsuite_util_pck.get_wsuite_expression_domain(9479, 'C003', c01_w.cd_estabelecimento),'C003', c01_w.nr_sequencia, nm_usuario_p);
			end if;

			qt_registro_w := 0;
			select  count(1)
			into STRICT	qt_registro_w
			from    pls_outorgante
			where   cd_ans = c01_w.cd_ans;

			if ( qt_registro_w = 0 ) then
				CALL audc_auditoria_concorrente_pck.audc_grava_mensagem( wsuite_util_pck.get_wsuite_expression_domain(9479, 'C004', c01_w.cd_estabelecimento),'C004', c01_w.nr_sequencia, nm_usuario_p);
			end if;

		end loop;

	end if;

	/* Validar regras de elegibilidade */


	CALL audc_auditoria_concorrente_pck.audc_valida_elegibilidade(nr_seq_lote_atend_imp_p, nm_usuario_p);

	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE audc_auditoria_concorrente_pck.audc_valida_atendimento_imp ( nr_seq_lote_atend_imp_p audc_lote_atendimento_imp.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
