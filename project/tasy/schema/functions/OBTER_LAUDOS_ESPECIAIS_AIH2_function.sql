-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_laudos_especiais_aih2 ( nr_atendimento_p bigint, ie_laudo_p bigint, ie_tipo_p bigint, nr_seq_interno_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_procedimento_w	bigint;
qt_laudo_w		integer	:= 1;
qt_procedimento_w	integer	:= 0;
cd_retorno_wW		bigint;
cd_retorno_w		bigint;

/* ie_tipo_p 
  1 - Cód. Procedimento 
  2 - Qtde Procedimento  */
 
 
C01 CURSOR FOR 
  SELECT	cd_procedimento_solic, 
      	qt_procedimento_solic 
  from		sus_laudo_paciente 
  where	nr_atendimento = 80899 
  and		ie_tipo_laudo_sus not in (0,1,15) 
  and (nr_Seq_interno	= nr_seq_interno_p or coalesce(nr_seq_interno_p::text, '') = '') 
  order by	nr_seq_interno;


BEGIN 
OPEN C01;
LOOP 
 
FETCH C01 into 
  cd_procedimento_w, 
  qt_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
  begin 
  if (ie_tipo_p   = 1) then 
      cd_retorno_ww  := cd_procedimento_w;
  elsif (ie_tipo_p   = 2) then 
      cd_retorno_ww  := qt_procedimento_w;
  end if;
  if (ie_laudo_p   = 1) and (qt_laudo_w   = 1) then 
      cd_retorno_w  := cd_retorno_ww;
  elsif (ie_laudo_p   = 2) and (qt_laudo_w   = 2) then 
      cd_retorno_w  := cd_retorno_ww;
  elsif (ie_laudo_p   = 3) and (qt_laudo_w   = 3) then 
      cd_retorno_w  := cd_retorno_ww;
  end if;
  qt_laudo_w   := qt_laudo_w + 1;
  end;
END LOOP;
CLOSE C01;
 
return   cd_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_laudos_especiais_aih2 ( nr_atendimento_p bigint, ie_laudo_p bigint, ie_tipo_p bigint, nr_seq_interno_p bigint) FROM PUBLIC;

