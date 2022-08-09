-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_peso_lavanderia (nr_seq_lavanderia_p rop_lavanderia.nr_sequencia%type) AS $body$
DECLARE

    qt_peso_w rop_lavanderia.qt_peso%type;


BEGIN
    select sum(coalesce(qt_peso, 0))
    into STRICT   qt_peso_w
    from   rop_lavanderia_item
    where  nr_seq_lavanderia = nr_seq_lavanderia_p;

    update rop_lavanderia
    set    qt_peso        = qt_peso_w,
           dt_atualizacao = clock_timestamp(),
           nm_usuario     = wheb_usuario_pck.get_nm_usuario
    where  nr_sequencia = nr_seq_lavanderia_p;
    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_peso_lavanderia (nr_seq_lavanderia_p rop_lavanderia.nr_sequencia%type) FROM PUBLIC;
