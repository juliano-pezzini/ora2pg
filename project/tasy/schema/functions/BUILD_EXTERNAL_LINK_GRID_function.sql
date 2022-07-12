-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION build_external_link_grid (nr_sequencia_in gqa_pend_pac_acao.nr_sequencia%type ) RETURNS varchar AS $body$
DECLARE


    nr_sequencia_p     gqa_pend_pac_acao.nr_seq_pend_pac%type not null := nr_sequencia_in;
    external_link_w       varchar(1000);
    ds_link_w             varchar(500);

    c_links CURSOR FOR
        SELECT substr(ds_link, 1) FROM gqa_pend_pac_acao WHERE 1=1
        AND nr_sequencia = nr_sequencia_p
        AND (ds_link IS NOT NULL AND ds_link::text <> '')
;


BEGIN
    OPEN c_links;
    LOOP
        FETCH c_links INTO ds_link_w;
        EXIT WHEN NOT FOUND; /* apply on c_links */
        BEGIN
          if (substr(ds_link_w, 1, 4) = 'http') then
            external_link_w := '<a href='||ds_link_w||' target=_blank>'|| ds_link_w ||'</a>';
          else
            external_link_w :=  '<a href=http://'||ds_link_w||' target=_blank>'|| ds_link_w ||'</a>';
          end if;
        END;

    END LOOP;
    CLOSE c_links;

return substr(external_link_w, 1, 1000);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION build_external_link_grid (nr_sequencia_in gqa_pend_pac_acao.nr_sequencia%type ) FROM PUBLIC;

