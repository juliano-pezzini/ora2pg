-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_gas_andamento ( nr_prescricao_p bigint, nr_atendimento_p bigint, nr_seq_gasoterapia_p bigint ) AS $body$
DECLARE


ie_status_w varchar(15);
nr_sequencia_w bigint;
nr_seq_gasote_w bigint;
dt_evento_w timestamp;

C01 CURSOR FOR
    SELECT  coalesce(a.ie_suspenso,'N'),
            coalesce(a.nr_sequencia,0)
    from    prescr_gasoterapia a,
            prescr_medica b
    where   a.nr_prescricao <> nr_prescricao_p
    and     a.nr_prescricao = b.nr_prescricao
    and     b.nr_atendimento = nr_atendimento_p
    and     a.nr_seq_gas = nr_seq_gasoterapia_p
    order by a.nr_sequencia;


BEGIN

if  (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_seq_gasoterapia_p IS NOT NULL AND nr_seq_gasoterapia_p::text <> '') then

    open C01;
    loop
    fetch C01 into
        ie_status_w,
        nr_seq_gasote_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
        begin
        select  coalesce(max('S'),ie_status_w)
        into STRICT    ie_status_w
        from    prescr_gasoterapia_evento a
        where   a.nr_seq_gasoterapia = nr_seq_gasote_w
        and     a.ie_evento in ('SH', 'S')
        and     coalesce(a.ie_evento_valido, 'S') = 'S';

        if (ie_status_w <> 'S') and (nr_seq_gasote_w <> 0)  then
            select  coalesce(max(a.nr_sequencia),0)
            into STRICT    nr_sequencia_w
            from    prescr_gasoterapia_evento a
            where   a.nr_seq_gasoterapia = nr_seq_gasote_w
            and     a.ie_evento in ('I', 'R', 'IN', 'TE', 'T')
            and     coalesce(a.ie_evento_valido, 'S') = 'S';

            if (nr_sequencia_w > 0) then
                select  max(ie_evento),
                        max(dt_evento)
                into STRICT    ie_status_w,
                        dt_evento_w
                from    prescr_gasoterapia_evento
                where   nr_sequencia = nr_sequencia_w
                and     ie_evento in ('I','IN','R');
            else
                ie_status_w := 'N';
            end if;

            if  (((ie_status_w <> 'TE') or (ie_status_w <> 'T')) and (dt_evento_w IS NOT NULL AND dt_evento_w::text <> ''))then
                -- Ja existe uma gasoterapia em andamento na data #@DIA#@, voce deve finalizar a mesma antes de iniciar uma nova
                CALL Wheb_mensagem_pck.exibir_mensagem_abort(obter_texto_dic_objeto(442098, wheb_usuario_pck.get_nr_seq_idioma, 'DIA=' || dt_evento_w));
            end if;
        end if;
        end;
    end loop;
    close C01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_gas_andamento ( nr_prescricao_p bigint, nr_atendimento_p bigint, nr_seq_gasoterapia_p bigint ) FROM PUBLIC;
