-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS gerint_ev_int_dados_aftinsert ON gerint_evento_int_dados CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_gerint_ev_int_dados_aftinsert() RETURNS trigger AS $BODY$
declare

nr_evento_integracao_w		bigint;
nm_usuario_w				gerint_evento_integracao.nm_usuario%type;
reg_integracao_w			gerar_int_padrao.reg_integracao; --Nao e utilizado. Apenas criado pois e obrigatorio na chamada da procedure GRAVAR_INTEGRACAO.
ds_param_adicional_w		varchar(100);
nr_cerih_w					gerint_evento_integracao.nr_protocolo_solicitacao%type;
cd_estab_w					GERINT_EVENTO_INTEGRACAO.cd_estabelecimento%type;

BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
		/*O evento 12 sempre sera gerado na trigger GERINT_EVENTO_INT_AFTINSERT pois nao envia dados, apenas recebe*/


		
		SELECT	CASE WHEN id_evento=1 THEN 88 WHEN id_evento= 	--Servico de bloqueio de leito
						2 THEN 89 WHEN id_evento= 	--Servico de desbloqueio de leito
						3 THEN 90 WHEN id_evento= 	--Servico de internacao
						4 THEN 91 WHEN id_evento= 	--Servico de internacao em um leito extra
						5 THEN 92 WHEN id_evento= 	--Servico de liberacao de internacao
						6 THEN 93 WHEN id_evento= 	--Servico de transferencia do leito da internacao
						7 THEN 94 WHEN id_evento= 	--Servico de reversao da internacao
						8 THEN 95 WHEN id_evento= 	--Servico de reversao da alta/obito
						9 THEN 96 WHEN id_evento= 	--Servico de solicitacao de internacao
						10 THEN 97 WHEN id_evento=	--Servico de nova evolucao do paciente
						11 THEN 99 WHEN id_evento=	--Servico de permuta de leito
						12 THEN 100 WHEN id_evento=	--Servico de consulta da situacao das Solicitacoes
						13 THEN 101 WHEN id_evento= --Servico de identificacao do paciente
						14 THEN 107 WHEN id_evento= --Servico de reinternacao da solicitacao
						16 THEN 136 WHEN id_evento= --Servico de solicitacao de transferencia de paciente.
						25 THEN  434 END , --Servico de ocupacao de leito sem solicitacao previa cadastrada no GERINT
				nm_usuario,
				nr_protocolo_solicitacao,
				cd_Estabelecimento
		INTO STRICT	nr_evento_integracao_w,
				nm_usuario_w,
				nr_cerih_w,
				cd_estab_w
		FROM	gerint_evento_integracao
		where	nr_sequencia = NEW.nr_seq_evento
		and		ie_situacao = 'N';
		
		reg_integracao_w.cd_estab_documento := cd_estab_w;
		
		if (nr_evento_integracao_w = 101) then
			ds_param_adicional_w := 'numeroCerih='||nr_cerih_w||';';
		end if;

		if (nr_evento_integracao_w is not null AND nr_evento_integracao_w <> 12 AND NEW.nr_seq_evento > 0)then
			reg_integracao_w := gerar_int_padrao.gravar_integracao(nr_evento_integracao_w, NEW.nr_seq_evento, nm_usuario_w, reg_integracao_w, ds_param_adicional_w);
		end if;
end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_gerint_ev_int_dados_aftinsert() FROM PUBLIC;

CREATE TRIGGER gerint_ev_int_dados_aftinsert
	AFTER INSERT ON gerint_evento_int_dados FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_gerint_ev_int_dados_aftinsert();
