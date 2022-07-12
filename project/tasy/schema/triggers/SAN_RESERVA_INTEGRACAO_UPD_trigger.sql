-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS san_reserva_integracao_upd ON san_reserva_integracao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_san_reserva_integracao_upd() RETURNS trigger AS $BODY$
declare
  qt_registro_w		bigint;
  nr_sequencia_w		bigint;
  nr_seq_entidade_w   bigint;
  cd_pessoa_fisica_w	varchar(10);
  cd_medico_resp_w 	varchar(10);
  cd_convenio_w		integer;
  cd_derivado_w		varchar(40);
  qt_solicitada_w	san_reserva_item.qt_solicitada%type;
  nr_seq_item_w		integer := 1;
  nr_seq_iteg_item_w	bigint;
  ie_irradiado_w	varchar(1);
  ie_lavado_w		varchar(1);
  ie_filtrado_w		varchar(1);
  ie_aliquotado_w	varchar(1);

  C01 CURSOR FOR
    SELECT  	nr_sequencia,
		cd_derivado,
		qt_solicitada,
		ie_irradiado,
		ie_lavado,
		ie_filtrado,
		ie_aliquotado
    from    san_res_integ_item
    where   nr_seq_res_integracao = NEW.nr_sequencia;

BEGIN

  if (NEW.ie_status_requisicao = 'L') then

    select  count(1)
    into STRICT	qt_registro_w
    from    atendimento_paciente
    where   nr_atendimento = NEW.nr_atendimento;

    if qt_registro_w = 0 then

      CALL gravar_log_tasy(3470, wheb_mensagem_pck.get_texto(794870,
						'NR_ATENDIMENTO='||NEW.nr_atendimento||
						';NR_SEQUENCIA='||NEW.nr_sequencia), NEW.nm_usuario);
      NEW.ie_status_requisicao := 'E';

    elsif qt_registro_w > 0 then

      select	nextval('san_reserva_seq')
      into STRICT	nr_sequencia_w
;

      select  max(cd_pessoa_fisica), max(cd_medico_resp)
      into STRICT    cd_pessoa_fisica_w, cd_medico_resp_w
      from    atendimento_paciente
      where   nr_atendimento = NEW.nr_atendimento;

      select  max(cd_convenio)
      into STRICT	cd_convenio_w
      from    atend_categoria_convenio
      where   nr_atendimento = NEW.nr_atendimento;

      select	max(nr_seq_entidade)
      into STRICT	nr_seq_entidade_w
      from	san_parametro
      where	cd_estabelecimento = 1;

      insert into san_reserva(nr_sequencia,
          dt_atualizacao,
          nm_usuario,
          dt_atualizacao_nrec,
          nm_usuario_nrec,
          nr_atendimento,
          cd_pessoa_fisica,
          dt_cirurgia,
          dt_reserva,
          cd_pf_realizou,
          cd_medico_requisitante,
          cd_convenio,
          ie_status,
          nr_seq_entidade,
          cd_estabelecimento)
          values (nr_sequencia_w,
          LOCALTIMESTAMP,
          'TASY',
          LOCALTIMESTAMP,
          'TASY',
          NEW.nr_atendimento,
          cd_pessoa_fisica_w,
          LOCALTIMESTAMP,
          LOCALTIMESTAMP,
          cd_medico_resp_w,
          cd_medico_resp_w,
          cd_convenio_w,
          'R',
          nr_seq_entidade_w,
          1);

      NEW.NR_SEQ_RESERVA := nr_sequencia_w;

      open C01;
      loop
      fetch C01 into
        nr_seq_iteg_item_w,
	cd_derivado_w,
        qt_solicitada_w,
	ie_irradiado_w,
	ie_lavado_w,
	ie_filtrado_w,
	ie_aliquotado_w;
      EXIT WHEN NOT FOUND; /* apply on C01 */

      BEGIN
          select  coalesce(max(nr_sequencia),0)
          into STRICT    qt_registro_w
          from    san_derivado
          where   cd_externo = cd_derivado_w;

          if qt_registro_w = 0 then

            CALL gravar_log_tasy(3470, wheb_mensagem_pck.get_texto(794871,
							'CD_DERIVADO='||cd_derivado_w||
							';NR_SEQ_ITEG_ITEM='||nr_seq_iteg_item_w||
							';NR_SEQUENCIA='||NEW.nr_sequencia), NEW.nm_usuario);
            NEW.ie_status_requisicao := 'E';

          elsif qt_registro_w > 0 then

            insert into san_reserva_item(nr_seq_reserva,
                nr_seq_item,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                nr_seq_derivado,
                qt_solicitada,
                ie_util_hemocomponente,
                ie_suspenso,
		ie_irradiado,
		ie_lavado,
		ie_filtrado,
		ie_aliquotado)
              values (nr_sequencia_w,
                nr_seq_item_w,
                LOCALTIMESTAMP,
                'TASY',
                LOCALTIMESTAMP,
                'TASY',
                qt_registro_w,
                coalesce(qt_solicitada_w,1),
                'R',
                'N',
		ie_irradiado_w,
		ie_lavado_w,
		ie_filtrado_w,
		ie_aliquotado_w);

            nr_seq_item_w := nr_seq_item_w + 1;

          end if;
             end;
      end loop;
      close C01;

      if NEW.ie_status_requisicao = 'L' then --garante que o status não mudou durante a rotina para E - Erro
        NEW.ie_status_requisicao := 'P';
      end if;

    end if;
  end if;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_san_reserva_integracao_upd() FROM PUBLIC;

CREATE TRIGGER san_reserva_integracao_upd
	BEFORE UPDATE ON san_reserva_integracao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_san_reserva_integracao_upd();
