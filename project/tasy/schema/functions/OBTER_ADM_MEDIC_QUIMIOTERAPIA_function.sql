-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_adm_medic_quimioterapia ( nr_seq_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(255);
ie_administracao_w	varchar(5);
qt_pendente_w		bigint	:= 0;
qt_parcial_w		bigint	:= 0;
qt_total_w		bigint	:= 0;
qt_medic_w		bigint	:= 0;

c01 CURSOR FOR
	SELECT	coalesce(ie_administracao, 'P')
	from	paciente_atend_medic
	where	nr_seq_atendimento = nr_seq_atendimento_p
	and	coalesce(nr_seq_diluicao::text, '') = '';


BEGIN

--Verifica o total de medicamentos para o paciente
select	count(*)
into STRICT	qt_medic_w
from	paciente_atend_medic
where	nr_seq_atendimento = nr_seq_atendimento_p
and	coalesce(nr_seq_diluicao::text, '') = '';

--Conta cada um dos medicamentos e agrupa por status (DOM 1853)
open c01;
loop
fetch C01 into
	ie_administracao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	--Conta a administração pelos status dos medicamentos
	if (ie_administracao_w = 'P') then
		qt_pendente_w	:= qt_pendente_w + 1;
	elsif (ie_administracao_w = 'AP') then
		qt_parcial_w	:= qt_parcial_w + 1;
	elsif (ie_administracao_w = 'A') then
		qt_total_w	:= qt_total_w + 1;
	end if;
	end;
end loop;
close c01;

--Verifica as quantidades para retornar
if (qt_medic_w = 0) then
  ds_retorno_w    := wheb_mensagem_pck.get_texto(308053); -- Sem medicação informada
elsif (qt_total_w = qt_medic_w) then
  ds_retorno_w    := wheb_mensagem_pck.get_texto(308054); -- Administração total
elsif (qt_pendente_w = qt_medic_w) then
  ds_retorno_w    := wheb_mensagem_pck.get_texto(308055); -- Pendente de administração
else
  ds_retorno_w    := wheb_mensagem_pck.get_texto(308056); -- Administração parcial
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_adm_medic_quimioterapia ( nr_seq_atendimento_p bigint) FROM PUBLIC;

