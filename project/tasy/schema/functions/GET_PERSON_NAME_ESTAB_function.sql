
-- FUNCTION: public.get_person_name_estab(text, text, smallint)

-- DROP FUNCTION IF EXISTS public.get_person_name_estab(text, text, smallint);

CREATE OR REPLACE FUNCTION public.get_person_name_estab(
	cd_physical_person_p text,
	nm_physical_person_p text,
	cd_establishment_p smallint DEFAULT NULL::smallint)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    STABLE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
DECLARE

person_name_result person_name_dev_row;

ds_return_w		varchar(60);
nr_seq_person_name_w		pessoa_fisica.nr_seq_person_name%type;

BEGIN
if (cd_physical_person_p IS NOT NULL AND cd_physical_person_p::text <> '') then
	begin

	select	max(nr_seq_person_name)
	into STRICT	nr_seq_person_name_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_physical_person_p;


    person_name_result = search_names_dev(null, cd_physical_person_p, nr_seq_person_name_w, null, null, cd_establishment_p);
	select	substr(nm_pessoa_fisica,1,60) into STRICT	ds_return_w from pessoa_fisica where cd_pessoa_fisica = person_name_result.cd_pessoa_fisica;

    return ds_return_w;

	end;
else
	return nm_physical_person_p;
end if;

return ds_return_w;

end;
$BODY$;

ALTER FUNCTION public.get_person_name_estab(text, text, smallint)
    OWNER TO postgres;

