-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION suep_algorithms_severit_cv ( nr_pontuacao_p bigint, nr_seq_sis_corpo_hum_item_p bigint) RETURNS varchar AS $body$
DECLARE

   c01 CURSOR FOR
      SELECT a.nr_seq_exame,
             a.nr_seq_sinal,
             a.nr_seq_escala_doc,
             a.nr_baixa_severa_sa,
             a.nr_baixa_moderada_sa,
             a.nr_alta_moderada_sa,
             a.nr_alta_severa_sa
        from sistema_corpo_humano_item a
       where a.nr_sequencia = nr_seq_sis_corpo_hum_item_p;
ds_return_w		varchar(50):='black';

BEGIN

if (nr_pontuacao_p IS NOT NULL AND nr_pontuacao_p::text <> '' AND nr_seq_sis_corpo_hum_item_p IS NOT NULL AND nr_seq_sis_corpo_hum_item_p::text <> '')	then

  for r_c01 in c01 loop

            
               if ((r_c01.nr_alta_moderada_sa IS NOT NULL AND r_c01.nr_alta_moderada_sa::text <> '') and
                  (r_c01.nr_alta_severa_sa IS NOT NULL AND r_c01.nr_alta_severa_sa::text <> '') and
                  (r_c01.nr_baixa_moderada_sa IS NOT NULL AND r_c01.nr_baixa_moderada_sa::text <> '') and
                  (r_c01.nr_baixa_severa_sa IS NOT NULL AND r_c01.nr_baixa_severa_sa::text <> '')) then
                  
                  
                  CASE
                  
                     WHEN ((nr_pontuacao_p < r_c01.nr_baixa_severa_sa) OR (nr_pontuacao_p > r_c01.nr_alta_severa_sa)) THEN
                        ds_return_w := 'red';
                     WHEN ((nr_pontuacao_p >= r_c01.nr_baixa_severa_sa AND nr_pontuacao_p < r_c01.nr_baixa_moderada_sa) OR (nr_pontuacao_p > r_c01.nr_alta_moderada_sa) AND (nr_pontuacao_p <= r_c01.nr_alta_severa_sa)) THEN
                        ds_return_w := 'yellow';
                     WHEN (nr_pontuacao_p >= r_c01.nr_baixa_moderada_sa AND nr_pontuacao_p <= r_c01.nr_alta_moderada_sa) THEN
                        ds_return_w := 'gray';

                  END CASE;

               elsif (r_c01.nr_alta_moderada_sa IS NOT NULL AND r_c01.nr_alta_moderada_sa::text <> '' AND r_c01.nr_alta_severa_sa IS NOT NULL AND r_c01.nr_alta_severa_sa::text <> '') then
               
                  CASE
                  
                     WHEN(nr_pontuacao_p <= r_c01.nr_alta_moderada_sa) THEN
                        ds_return_w := 'gray';
                     WHEN (nr_pontuacao_p > r_c01.nr_alta_moderada_sa AND nr_pontuacao_p <= r_c01.nr_alta_severa_sa) THEN
                        ds_return_w := 'yellow';
                     WHEN(nr_pontuacao_p > r_c01.nr_alta_severa_sa) THEN
                        ds_return_w := 'red';
                  END CASE;
               elsif (r_c01.nr_baixa_moderada_sa IS NOT NULL AND r_c01.nr_baixa_moderada_sa::text <> '' AND r_c01.nr_baixa_severa_sa IS NOT NULL AND r_c01.nr_baixa_severa_sa::text <> '') then               
                  CASE                  
                     WHEN(nr_pontuacao_p >= r_c01.nr_baixa_moderada_sa) THEN
                        ds_return_w := 'gray';
                     WHEN (nr_pontuacao_p < r_c01.nr_baixa_moderada_sa AND nr_pontuacao_p >= r_c01.nr_baixa_severa_sa) THEN
                        ds_return_w := 'yellow';
                     WHEN(nr_pontuacao_p < r_c01.nr_baixa_severa_sa) THEN
                        ds_return_w := 'red';
                  END CASE;
               end if;


         end loop;

end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION suep_algorithms_severit_cv ( nr_pontuacao_p bigint, nr_seq_sis_corpo_hum_item_p bigint) FROM PUBLIC;
