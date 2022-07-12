-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ativ_lib_colab_migr ( nr_seq_ativ_p bigint, ie_tipo_os_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_liberada_w	varchar(1) := 'N';


BEGIN
if (nr_seq_ativ_p IS NOT NULL AND nr_seq_ativ_p::text <> '') and (ie_tipo_os_p IS NOT NULL AND ie_tipo_os_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (nm_usuario_p = 'Rafael') or (nm_usuario_p = 'jahfilho') or (nm_usuario_p = 'Jerusa') or (nm_usuario_p = 'dsilva') or (nm_usuario_p = 'rfcaldas') or (nm_usuario_p = 'pfsilva') or (nm_usuario_p = 'jcschmitt') or (nm_usuario_p = 'jpweiss') or (nm_usuario_p = 'jojunior') or (nm_usuario_p = 'wborba') or (nm_usuario_p = 'hhlopes') or (nm_usuario_p = 'gpereira') or (nm_usuario_p = 'tfferretti') or (nm_usuario_p = 'aarbigaus') or (nm_usuario_p = 'mmueller') or (nm_usuario_p = 'Dalcastagne') or (nm_usuario_p = 'jlweigmann') or (nm_usuario_p = 'phfcampos') or (nm_usuario_p = 'lwilbert') or (nm_usuario_p = 'rzimmermann') or (nm_usuario_p = 'crdossi') or (nm_usuario_p = 'jcurbano') or (nm_usuario_p = 'emafezzoli') or (nm_usuario_p = 'gkpiaz') or (nm_usuario_p = 'Edilson') or (nm_usuario_p = 'abmaciel') or (nm_usuario_p = 'Martini') or (nm_usuario_p = 'jdalponte') or (nm_usuario_p = 'ahkienolt') or (nm_usuario_p = 'mhfischer') or (nm_usuario_p = 'lafeller') or (nm_usuario_p = 'cpdias') or (nm_usuario_p = 'Juliane') or (nm_usuario_p = 'cfsouza') or (nm_usuario_p = 'wcsilva') or (nm_usuario_p = 'eberns') or (nm_usuario_p = 'africhart') or (nm_usuario_p = 'alcornetet') or (nm_usuario_p = 'mzcorreia') or (nm_usuario_p = 'Donhini') or (nm_usuario_p = 'tbyegmann') or (nm_usuario_p = 'bdnicoletti') or (nm_usuario_p = 'ctarruda') or (nm_usuario_p = 'tbschulz') or (nm_usuario_p = 'rhtakano') or (nm_usuario_p = 'Andre') or (nm_usuario_p = 'prmarangoni') or (nm_usuario_p = 'aoliveira') or (nm_usuario_p = 'tabeckhauser') or (nm_usuario_p = 'thlima') or (nm_usuario_p = 'amramos') or (nm_usuario_p = 'whespthal') or (nm_usuario_p = 'taoliveira') or (nm_usuario_p = 'ascarneiro') or (nm_usuario_p = 'mkath') or (nm_usuario_p = 'waskroth') or (nm_usuario_p = 'lfhinckel') then
		begin
		ie_liberada_w := 'S';
		end;
	elsif (obter_se_usuario_desenv_migr(nm_usuario_p) = 'S') then
		begin
		if (ie_tipo_os_p in ('PU','RU')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '11');
			end;
		elsif (ie_tipo_os_p in ('PT','VT','DT','CT','UT')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '22,132');
			end;
		elsif (ie_tipo_os_p in ('RT')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '11,22');
			end;
		elsif (ie_tipo_os_p in ('VU','DU')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '132');
			end;
		/*elsif	(ie_tipo_os_p in ('TU','TT')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '0');
			end;*/
		elsif (ie_tipo_os_p in ('T')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '0');
			end;
		elsif (ie_tipo_os_p in ('CU')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '11');
			end;
		elsif (ie_tipo_os_p in ('UU')) then
			begin
			ie_liberada_w := obter_se_contido(nr_seq_ativ_p, '11,132');
			end;
		end if;
		end;
	else
		begin
		ie_liberada_w := 'S';
		end;
	end if;
	end;
end if;
return ie_liberada_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ativ_lib_colab_migr ( nr_seq_ativ_p bigint, ie_tipo_os_p text, nm_usuario_p text) FROM PUBLIC;

