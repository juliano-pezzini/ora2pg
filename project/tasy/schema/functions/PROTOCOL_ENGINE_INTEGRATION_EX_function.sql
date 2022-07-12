-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function protocol_engine_integration_ex as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION protocol_engine_integration_ex (nr_atendimento_p text, cd_evento_p integer, nr_seq_sv integer default null, nr_seq_exame_p integer default null) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM protocol_engine_integration_ex_atx ( ' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(cd_evento_p) || ',' || quote_nullable(nr_seq_sv) || ',' || quote_nullable(nr_seq_exame_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION protocol_engine_integration_ex_atx (nr_atendimento_p text, cd_evento_p integer, nr_seq_sv integer default null, nr_seq_exame_p integer default null) RETURNS varchar AS $body$
DECLARE


    -- Constantes
    Leukocytosis                     integer      :=  12;
    Leukopenia                       integer      :=  13;

    -- variaveis
    ds_param_integ_hl7_w	        varchar(4000) := null;
    nr_result_lab_exame_w		    bigint;
    qt_hora_exame_w				    smallint;
    qt_resultado_exame_w			double precision;
    nr_seq_exame_w				    bigint     := null;
    nr_tipo_exame_w                 integer        := null;
BEGIN

    select	max(coalesce(nr_seq_exame  , 0)),
            max(coalesce(qt_hora_exame , 0)),
            max(coalesce(b.nr_sequencia, 0))
    into STRICT	nr_seq_exame_w,
            qt_hora_exame_w,
            nr_tipo_exame_w
    from	sepse_atributo_regra a,
            sepse_atributo       b
    where	a.nr_seq_atributo = b.nr_sequencia
    and		a.nr_seq_exame    = nr_seq_exame_p
    and     b.nr_sequencia in (12, 13);

    if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

        select  max(coalesce(b.qt_resultado, 0)),
                max(coalesce(b.nr_seq_resultado, 0))
        into STRICT    qt_resultado_exame_w,
                nr_result_lab_exame_w
        from    exame_lab_result_item b,
                exame_lab_resultado   a,
                prescr_procedimento   x,
                prescr_medica         c
        where   a.nr_seq_resultado= b.nr_seq_resultado
        and     a.nr_prescricao   = c.nr_prescricao
        and     x.nr_sequencia    = b.nr_seq_prescr
        and     x.nr_prescricao   = c.nr_prescricao
        and     b.nr_seq_exame    = nr_seq_exame_w
        and     c.nr_atendimento  = nr_atendimento_p
        and     x.ie_status_atend >= 35
        and		((qt_hora_exame_w = 0) or (a.dt_resultado between (clock_timestamp()-(qt_hora_exame_w/24)) and clock_timestamp()));

        if qt_resultado_exame_w > 0 then

            if nr_tipo_exame_w = Leukocytosis then
                ds_param_integ_hl7_w :=   'nr_atendimento='     || nr_atendimento_p      || ';'  ||
                                          'nr_tipo_exame='      || Leukocytosis          || ';'  ||
                                          'nr_seq_resultado='   || nr_result_lab_exame_w || ';';

            elsif nr_tipo_exame_w = Leukopenia then
                ds_param_integ_hl7_w :=   'nr_atendimento='     || nr_atendimento_p      || ';'  ||
                                          'nr_tipo_exame='      || Leukopenia            || ';'  ||
                                          'nr_seq_resultado='   || nr_result_lab_exame_w || ';';
            end if;

        end if;

    end if;

    return  ds_param_integ_hl7_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION protocol_engine_integration_ex (nr_atendimento_p text, cd_evento_p integer, nr_seq_sv integer default null, nr_seq_exame_p integer default null) FROM PUBLIC; -- REVOKE ALL ON FUNCTION protocol_engine_integration_ex_atx (nr_atendimento_p text, cd_evento_p integer, nr_seq_sv integer default null, nr_seq_exame_p integer default null) FROM PUBLIC;

