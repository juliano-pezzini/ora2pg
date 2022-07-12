-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_status_processo ( ie_status_processo_p text ) RETURNS bigint AS $body$
DECLARE


nr_seq_execucao_w	smallint := 0;


BEGIN

if (ie_status_processo_p = 'G') then
	nr_seq_execucao_w	:= 1;
elsif (ie_status_processo_p = 'D') then
	nr_seq_execucao_w	:= 2;
elsif (ie_status_processo_p = 'H') then
	nr_seq_execucao_w	:= 3;
elsif (ie_status_processo_p = 'P') then
	nr_seq_execucao_w	:= 4;
elsif (ie_status_processo_p = 'L') then
	nr_seq_execucao_w	:= 5;
elsif (ie_status_processo_p = 'R') then
	nr_seq_execucao_w	:= 6;
elsif (ie_status_processo_p = 'A') then
	nr_seq_execucao_w	:= 7;
end if;

return nr_seq_execucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_status_processo ( ie_status_processo_p text ) FROM PUBLIC;
