-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS mat_autor_bono ON material_autorizado CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_mat_autor_bono() RETURNS trigger AS $BODY$
DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;

qt_bonus_w		MATERIAL_AUTORIZADO.QT_BONUS%type;
cd_convenio_w		CONVENIO.CD_CONVENIO%type;
nr_atendimento_w	ATENDIMENTO_PACIENTE.NR_ATENDIMENTO%type;
ie_valida_bono_w	CONVENIO.IE_VALIDA_BONO%type;
nr_seq_regra_plano_w	REGRA_CONVENIO_PLANO.NR_SEQUENCIA%type;
dt_atend_medico_w	ATENDIMENTO_PACIENTE.DT_ATEND_MEDICO%type;
qt_w                    MATERIAL_AUTORIZADO.QT_BONUS_APRES%type;

BEGIN
IF (wheb_usuario_pck.get_ie_executar_trigger = 'S') THEN
        SELECT	coalesce(MAX(a.IE_VALIDA_BONO), 'N')
        INTO STRICT 	ie_valida_bono_w
        FROM 	CONVENIO a,
                AUTORIZACAO_CONVENIO b
        WHERE   a.CD_CONVENIO 	= b.CD_CONVENIO
        AND 	b.NR_SEQUENCIA 	= NEW.NR_SEQUENCIA_AUTOR;

        IF (ie_valida_bono_w = 'S') THEN
                SELECT  MAX(b.NR_ATENDIMENTO),
                        MAX(b.CD_CONVENIO)
                INTO STRICT	nr_atendimento_w,
                        cd_convenio_w
                FROM	MATERIAL_AUTORIZADO a,
                        AUTORIZACAO_CONVENIO b
                WHERE   a.NR_SEQUENCIA_AUTOR 	= b.NR_SEQUENCIA
                AND 	b.NR_SEQUENCIA 		= NEW.NR_SEQUENCIA_AUTOR
                AND 	a.CD_MATERIAL 		= NEW.CD_MATERIAL;

                SELECT	MAX(a.DT_ATEND_MEDICO)
                INTO STRICT	dt_atend_medico_w
                FROM	ATENDIMENTO_PACIENTE a
                WHERE	a.NR_ATENDIMENTO = nr_atendimento_w;

                SELECT * FROM REQUIRED_AMOUNT_MAT_BONUS(
                        nr_atendimento_p 	=> nr_atendimento_w, cd_convenio_p 		=> cd_convenio_w, cd_material_p 		=> NEW.CD_MATERIAL, dt_atendimento_p 	=> dt_atend_medico_w, qt_material_p 		=> NEW.QT_AUTORIZADA, nr_seq_regra_p 		=> nr_seq_regra_plano_w, qt_bonus_p 		=> qt_bonus_w
                ) INTO STRICT nr_seq_regra_p 		=> nr_seq_regra_plano_w, qt_bonus_p 		=> qt_bonus_w
;

                NEW.QT_BONUS     	:= qt_bonus_w;
                NEW.NR_SEQ_REGRA_PLANO := nr_seq_regra_plano_w;
                if (TG_OP = 'INSERT' or TG_OP = 'UPDATE') then
                        select sum(qt)
                        into STRICT   qt_w
                        from (
                                SELECT sum(a.qt_bonus_apres) qt
                                from   material_autorizado a
                                where  a.nr_sequencia_autor  = NEW.nr_sequencia_autor
                                and a.nr_sequencia <> NEW.nr_sequencia

union all

                                SELECT sum(b.qt_bonus_apres) qt
                                from   procedimento_autorizado b
                                where  b.nr_sequencia_autor  = NEW.nr_sequencia_autor) alias4;
                        
                                qt_w := qt_w + NEW.qt_bonus_apres;
                                update autorizacao_convenio
                                set    qt_bonus_apres = qt_w
                                where  nr_sequencia = NEW.nr_sequencia_autor;
                                commit;
                        else
                                select  coalesce(max(qt_bonus_apres),0)
                                into STRICT    qt_w
                                from    autorizacao_convenio
                                where  nr_sequencia = OLD.nr_sequencia_autor;
                                qt_w := qt_w - coalesce(OLD.qt_bonus_apres,0);
                                update autorizacao_convenio
                                set    qt_bonus_apres = qt_w
                                where  nr_sequencia = OLD.nr_sequencia_autor;
                                commit;
                end if;
        END IF;
END IF;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_mat_autor_bono() FROM PUBLIC;

CREATE TRIGGER mat_autor_bono
	BEFORE INSERT OR UPDATE OR DELETE ON material_autorizado FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_mat_autor_bono();
