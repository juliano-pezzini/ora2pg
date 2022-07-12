-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_funcao_medico_jp (nr_atendimento_p bigint, ie_tipo_lista_p text) RETURNS varchar AS $body$
DECLARE


  nm_profisional_w varchar(255);
  ds_retorno_w     varchar(255) := '';

  c01 CURSOR(ie_medico_p text,ie_auxiliar_p text)FOR
    SELECT substr(obter_nome_pf(b.cd_profissional), 1, 15)
      from funcao_medico a,
           atend_paciente_medico b
       where b.nr_atendimento = nr_atendimento_p
       and a.cd_funcao   = b.nr_seq_func_medico
       and a.ie_medico   = ie_medico_p
       and a.ie_auxiliar = ie_auxiliar_p;

  c02 CURSOR(ie_enfermeira_p text,ie_auxiliar_p text)FOR
    SELECT substr(obter_nome_pf(b.cd_profissional), 1, 15)
      from funcao_medico a,
           atend_paciente_medico b
       where b.nr_atendimento = nr_atendimento_p
       and a.cd_funcao        = b.nr_seq_func_medico
       and a.ie_enfermeira    = ie_enfermeira_p
       and a.ie_auxiliar      = ie_auxiliar_p;


BEGIN

  if (ie_tipo_lista_p = 'ME') then 
     open c01('S','N');
     loop
        fetch c01
          into nm_profisional_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
          ds_retorno_w := ds_retorno_w || ',' || nm_profisional_w;
     end loop;
     close c01;

  end if;

  if (ie_tipo_lista_p = 'MA') then
     open c01('S','S');
     loop
        fetch c01
          into nm_profisional_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
          ds_retorno_w := ds_retorno_w || ',' || nm_profisional_w;
     end loop;
     close c01;

  end if;

  if (ie_tipo_lista_p = 'PE') then
     open c02('S','N');
     loop
        fetch c02
          into nm_profisional_w;
        EXIT WHEN NOT FOUND; /* apply on c02 */
          ds_retorno_w := ds_retorno_w || ',' || nm_profisional_w;
     end loop;
     close c02;

  end if;

  if (ie_tipo_lista_p = 'SE') then
     open c02('S','S');
     loop
        fetch c02
          into nm_profisional_w;
        EXIT WHEN NOT FOUND; /* apply on c02 */
          ds_retorno_w := ds_retorno_w || ',' || nm_profisional_w;
     end loop;
     close c02;
  end if;

  select substr(ds_retorno_w, 2, Length(ds_retorno_w))
    into STRICT ds_retorno_w
;

  return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_funcao_medico_jp (nr_atendimento_p bigint, ie_tipo_lista_p text) FROM PUBLIC;
