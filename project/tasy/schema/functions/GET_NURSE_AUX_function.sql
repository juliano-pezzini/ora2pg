-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_nurse_aux (nr_atendimento_p atend_enfermagem_aux.nr_atendimento%type, nr_order_p atend_enfermagem_aux.nr_ordem%type, option_p text ) RETURNS varchar AS $body$
DECLARE


nr_seq_phs_w                atend_enfermagem_aux.nr_seq_phs%type;
name_w                      varchar(60);
nr_phs_w                    phs_phone_number.nr_phs%type;

c1 CURSOR FOR
          SELECT  nr_seq_phs,
        obter_nome_pf(cd_pessoa_fisica) name_pf
from (
            SELECT      ax.nr_seq_phs,
                        ax.cd_pessoa_fisica
            from        atend_enfermagem_aux ax
            where       ax.nr_atendimento = nr_atendimento_p
            and         ax.nr_ordem = nr_order_p
            and         coalesce(ax.dt_final_resp::text, '') = ''
            order by    ax.nr_sequencia desc
) alias2 LIMIT 1;



BEGIN

   open c1;

     loop
            fetch c1 into
                nr_seq_phs_w,
                name_w;
            EXIT WHEN NOT FOUND; /* apply on c1 */
        end loop;
	close c1;

if option_p = 'N' then
    return name_w;
else   
    select coalesce(phs.nr_phs,'0')
    into STRICT nr_phs_w
    from phs_phone_number phs
    where phs.nr_sequencia=nr_seq_phs_w;
    return nr_phs_w;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_nurse_aux (nr_atendimento_p atend_enfermagem_aux.nr_atendimento%type, nr_order_p atend_enfermagem_aux.nr_ordem%type, option_p text ) FROM PUBLIC;
