-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tax_active_listener_invoice ( establishment_p regra_trans_auto_nfe.cd_estabelecimento%type) RETURNS bigint AS $body$
DECLARE

  response_w              smallint := 0;
  listener_active_w       bigint;
  current_day_w				    integer;
  current_hour_w		      varchar(5);
  current_month_w				  varchar(10);
  current_final_month_w		varchar(10);
  parameter_39_w          varchar(1);
  parameter_43_w          varchar(1);

  C01 CURSOR FOR
    SELECT	nr_sequencia sequence_rule,
            dt_inicio start_date_rule,
            dt_final final_date_rule,
            replace(substr(to_char(hr_inicio, 'hh24:mi'), 1, 5), ':', '') start_hour_rule,
            replace(substr(to_char(hr_final, 'hh24:mi'), 1, 5), ':', '') final_hour_rule
    from	regra_trans_auto_nfe a
    where	a.cd_estabelecimento = establishment_p;
  vet01 C01%RowType;


BEGIN
  -- etapa 0: verificar se o estabelecimento em questao esta liberado para utilizar o envio automatico
  select  substr(coalesce(obter_valor_param_usuario('9909', 39, Obter_perfil_ativo, 'WebService' , establishment_p), 'N'), 1, 1),
          substr(coalesce(obter_valor_param_usuario('9909', 43, Obter_perfil_ativo, 'WebService' , establishment_p), 'N'), 1, 1)
  into STRICT    parameter_39_w,
          parameter_43_w
;

  -- se os parametros estiverem cadastrado vai para a etapa 1
  if (parameter_39_w = 'S' and parameter_43_w = 'S') then

    -- etapa 1: verifica se tem alguma listener cadastrado na base
    select  count(*)
    into STRICT    listener_active_w
    from    listener_integracao_ativo 
    where   nr_seq_listener in (9, 30, 34);

    -- se ele tiver listener cadastrado vai para a etapa 2
    if (listener_active_w >= 1) then

      -- etapa 2: verifica se tem alguma regra de horario ou data 
      select 	count(*)
      into STRICT	  listener_active_w
      from	  regra_trans_auto_nfe
      where	  cd_estabelecimento = establishment_p;

      -- se ele tiver alguma regra de data ou hora vai para a etapa 3
      if (listener_active_w >= 1) then

        -- etapa 3: compara a data atual ou a hora atual ou os dois ao mesmo tempo com o que ta na regra 
        select	(to_char(clock_timestamp(), 'dd'))::numeric ,
                replace(substr(to_char(clock_timestamp(), 'hh24:mi'), 1, 5), ':', ''),
                substr('01/'|| to_char(clock_timestamp(), 'mm/yyyy'), 1, 10),
                substr(to_char(last_day(clock_timestamp()), 'dd/mm/yyyy'), 1, 10)
        into STRICT	current_day_w,
              current_hour_w,
              current_month_w,
              current_final_month_w
;

        open C01;
          loop
            fetch C01 into vet01;
            EXIT WHEN NOT FOUND; /* apply on C01 */
            begin
              if 	(((vet01.start_date_rule IS NOT NULL AND vet01.start_date_rule::text <> '')
                and (vet01.final_date_rule IS NOT NULL AND vet01.final_date_rule::text <> '') 
                and (current_day_w >= vet01.start_date_rule)
                and (current_day_w <= vet01.final_date_rule)
                and ((current_hour_w)::numeric  >= (vet01.start_hour_rule)::numeric )
                and ((current_hour_w)::numeric  <= (vet01.final_hour_rule)::numeric ))
                or  ((coalesce(vet01.start_date_rule::text, '') = '') 
                and (coalesce(vet01.final_date_rule::text, '') = '') 
                and ((current_hour_w)::numeric  >= (vet01.start_hour_rule)::numeric )
                and ((current_hour_w)::numeric  <= (vet01.final_hour_rule)::numeric ))) then
                response_w := 1;
              end if;
            end;
          end loop;
        close C01;
      else
        response_w := 1;
      end if;
    end if;
  end if;

  return response_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tax_active_listener_invoice ( establishment_p regra_trans_auto_nfe.cd_estabelecimento%type) FROM PUBLIC;

