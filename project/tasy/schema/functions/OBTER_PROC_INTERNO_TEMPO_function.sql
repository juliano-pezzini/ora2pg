-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_interno_tempo (nr_seq_proc_interno_p proc_interno_tempo.nr_seq_proc_interno%type) RETURNS PROC_INTERNO_TEMPO.QT_MIN_CIRUGIA%TYPE AS $body$
DECLARE

    qt_min_cirurgia_w proc_interno_tempo.qt_min_cirugia%type;

BEGIN

    begin
        select qt_min_cirugia
        into STRICT qt_min_cirurgia_w 
        from proc_interno_tempo pt1 
        where nr_seq_proc_interno = nr_seq_proc_interno_p 
        and dt_atualizacao = (SELECT max(pt2.dt_atualizacao) 
                              from proc_interno_tempo pt2 
                              where pt2.nr_seq_proc_interno = pt1.nr_seq_proc_interno );
    exception
      when others then
       qt_min_cirurgia_w:= null;
    end;
    
    return qt_min_cirurgia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_interno_tempo (nr_seq_proc_interno_p proc_interno_tempo.nr_seq_proc_interno%type) FROM PUBLIC;
