-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_de_para_inf_apap_sv ( nr_seq_inf_apap_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_sv_w	bigint;


BEGIN
if (nr_seq_inf_apap_p = 13) then
	nr_seq_sv_w	:= 13;
elsif (nr_seq_inf_apap_p = 44) then
	nr_seq_sv_w	:= 10;
elsif (nr_seq_inf_apap_p = 152) then
	nr_seq_sv_w	:= 9;
elsif (nr_seq_inf_apap_p = 16) then
	nr_seq_sv_w	:= 3;
elsif (nr_seq_inf_apap_p = 51) then
	nr_seq_sv_w	:= 7;
elsif (nr_seq_inf_apap_p = 135) then
	nr_seq_sv_w	:= 14;
elsif (nr_seq_inf_apap_p = 14) then
	nr_seq_sv_w	:= 1;
elsif (nr_seq_inf_apap_p = 23) then
	nr_seq_sv_w	:= 2;
elsif (nr_seq_inf_apap_p = 55) then
	nr_seq_sv_w	:= 18;
elsif (nr_seq_inf_apap_p = 130) then
	nr_seq_sv_w	:= 22;
elsif (nr_seq_inf_apap_p = 12) then
	nr_seq_sv_w	:= 12;
elsif (nr_seq_inf_apap_p = 21) then
	nr_seq_sv_w	:= 16;
elsif (nr_seq_inf_apap_p = 129) then
	nr_seq_sv_w	:= 17;
elsif (nr_seq_inf_apap_p = 54) then
	nr_seq_sv_w	:= 6;
elsif (nr_seq_inf_apap_p = 134) then
	nr_seq_sv_w	:= 15;
elsif (nr_seq_inf_apap_p = 17) then
	nr_seq_sv_w	:= 4;
elsif (nr_seq_inf_apap_p = 15) then
	nr_seq_sv_w	:= 9;
else
	nr_seq_sv_w	:= null;
end if;

return nr_seq_sv_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_de_para_inf_apap_sv ( nr_seq_inf_apap_p bigint) FROM PUBLIC;
