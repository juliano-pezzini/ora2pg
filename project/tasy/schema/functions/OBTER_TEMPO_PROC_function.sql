-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_proc (nm_usuario_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qt_tempo_hig_w		varchar(200);
ie_soma_tempo_higi_w	varchar(1);
nr_min_duracao_w	bigint;


BEGIN

qt_tempo_hig_w := obter_param_usuario(871, 418, obter_perfil_ativo, nm_usuario_p, 0, qt_tempo_hig_w);
ie_soma_tempo_higi_w := obter_param_usuario(871, 362, obter_perfil_ativo, nm_usuario_p, 0, ie_soma_tempo_higi_w);

select 	nr_minuto_duracao
into STRICT	nr_min_duracao_w
from 	agenda_paciente
where 	nr_sequencia = nr_sequencia_p;

if (ie_soma_tempo_higi_w = 'S') then
	nr_min_duracao_w := nr_min_duracao_w - (qt_tempo_hig_w)::numeric;
end if;

return	nr_min_duracao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_proc (nm_usuario_p text, nr_sequencia_p bigint) FROM PUBLIC;
